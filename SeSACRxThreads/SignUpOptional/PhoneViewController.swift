//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 '-'없이 입력해주세요")
    let nextButton = PointButton(title: "다음")
    var phonNumberData = BehaviorRelay(value: "010")
    let basicColor = BehaviorSubject(value: UIColor.systemRed)
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

    }

    
    func bind() {
        phonNumberData
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        let validation = phoneTextField.rx.text.orEmpty
            .map { $0.count >= 10 && $0.range(of: "^[0-9]+$",options: .regularExpression) != nil}
        
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? UIColor.systemGreen : UIColor.systemRed
                owner.basicColor.onNext(color)
            }
            .disposed(by: disposeBag)
        basicColor
            .bind(to:
                nextButton.rx.backgroundColor,
                phoneTextField.rx.textColor,
                phoneTextField.rx.tintColor
            )
            .disposed(by: disposeBag)
        
        basicColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
