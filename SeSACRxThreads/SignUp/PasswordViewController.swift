//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let basicColor = BehaviorSubject(value: UIColor.systemRed)
    var colors = Observable.just(UIColor.green)
    var discriptionLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    let viewModel = PasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bindInOut()
        
    }
    func bindInOut() {
        let input = PasswordViewModel.Input(text: passwordTextField.rx.text,
                                            nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled,
                  discriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? UIColor.systemGreen : UIColor.systemRed
                // MARK: 이게 맞나..
                if !value {
                    owner.basicColor.onNext(color)
                    owner.discriptionLabel.rx.isHidden.onNext(value)
                    owner.discriptionLabel.rx.text.onNext("8자리 이상 입력하세요")
                } else {
                    owner.basicColor.onNext(color)
                    owner.discriptionLabel.rx.isHidden.onNext(value)
                }
            }
            .disposed(by: disposeBag)
        
        // BasicColor는 어떻게 하지? viewmodel에 UIkit 넣고싶지 않은데~
        // UI관련이니까 괜찮나 ?
        basicColor
            .bind(to:
                nextButton.rx.backgroundColor,
                passwordTextField.rx.textColor,
                passwordTextField.rx.tintColor
            )
            .disposed(by: disposeBag)
    
        basicColor
            .map { $0.cgColor }
            .bind(to: passwordTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        let a =  nextButton.rx.tap
        let validation = passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? UIColor.systemGreen : UIColor.systemRed
                owner.basicColor.onNext(color)
//                owner.discriptionLabel.rx.isHidden = !value
                owner.discriptionLabel.rx.text.onNext("8자리 이상 입력하세요")
            }
            .disposed(by: disposeBag)
        basicColor //Observable.just(UIColor.systemGreen)로 보낼게~
            .bind(to:
                nextButton.rx.backgroundColor,
                passwordTextField.rx.textColor,
                passwordTextField.rx.tintColor
            ) //nextButton.rx.어쩌구 -> rx특성으로 바꾸는 과정
            .disposed(by: disposeBag)
        
        // borderColor 는 cgColor이기 때문에 따로 바인딩 해줘야함 ~?!
        basicColor
            .map { $0.cgColor }
            .bind(to: passwordTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(discriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        discriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }


}
