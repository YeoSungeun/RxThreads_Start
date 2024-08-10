//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    let viewModel = NicknameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

    }
    func bind() {
        let a = nextButton.rx.tap
        
        let input = NicknameViewModel.Input(nicknameText: nicknameTextField.rx.text,
                                            nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.nicknameText
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
 
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
