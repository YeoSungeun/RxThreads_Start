//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let year = BehaviorRelay(value: Date().year)
    let month = BehaviorRelay(value: Date().month)
    let day = BehaviorRelay(value: Date().day)
    
    let viewModel = BirthdayViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }

    func bind() {
        let input = BirthdayViewModel.Input(birthday: birthDayPicker.rx.date,
                                            nextTap: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
       
        output.year
            .map { "\($0)년"}
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        output.month
            .bind(with: self) { owner, value in
                owner.monthLabel.rx.text.onNext("\(value)월")
            }
            .disposed(by: disposeBag)
        output.day
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.dayLabel.text = "\(value)일"
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        output.validation
            .bind(with: self) { owner, value in
                if value {
                    owner.infoLabel.rx.textColor.onNext(.systemGreen)
                    owner.nextButton.rx.backgroundColor.onNext(.systemGreen)
                } else {
                    owner.infoLabel.rx.textColor.onNext(.red)
                    owner.nextButton.rx.backgroundColor.onNext(.lightGray)
                }
            }
            .disposed(by: disposeBag)
        output.validText
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(ShoppingViewController(), animated: true)
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    func showAlert() {
        let alert = UIAlertController(
            title: "회원가입이 완료되었습니다.",
            message: nil,
            preferredStyle: .alert)
        let okay = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okay)
        present(alert, animated: true)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
