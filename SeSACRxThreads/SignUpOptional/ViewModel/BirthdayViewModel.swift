//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    struct Input {
        let birthday: ControlProperty<Date> //birthDayPicker.rx.date
        let nextTap: ControlEvent<Void>
    }
    struct Output {
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let nextTap: ControlEvent<Void>
        let validation: Observable<Bool>
        let validText: PublishRelay<String>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output{
        let year = BehaviorRelay(value: Date().year)
        let month = BehaviorRelay(value: Date().month)
        let day = BehaviorRelay(value: Date().day)
        let validText = PublishRelay<String>()
        input.birthday
            .bind(with: self) { owner, value in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: value)
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        let validation = input.birthday
            .map { value -> Bool in
                let date17th = Calendar.current.date(byAdding: .year, value: -17, to: Date())!
                print(date17th.onlyDate)
                if date17th.onlyDate >= value {
                    return true
                } else {
                    return false
                }
            }

        validation
            .bind(with: self) { owner, value in
                if value {
                    validText.accept("가입 가능한 나이입니다.")
                } else {
                    validText.accept("만17세 이상만 가입 가능합니다.")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(year: year,
                      month: month,
                      day: day,
                      nextTap: input.nextTap,
                      validation: validation,
                      validText: validText)
    }
}

// input
// datepicker의 날짜
// nextButtonTap

// output
// year, month, day -> 받은거 처리해줘야지~~ 그래서 subject로 해야되나 ?
// nextTap
