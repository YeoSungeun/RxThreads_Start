//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    struct Input {
        let tap: ControlEvent<Void> // nextButton.rx.tap
        let text: ControlProperty<String?> // phoneTextField.rx.text
    }
    struct Output {
        let tap: ControlEvent<Void>
        let validation: Observable<Bool>
    }
    func transform(input: Input) -> Output {
        let validation = input.text
            .orEmpty
            .map { $0.count >= 10 && $0.range(of: "^[0-9]+$",options: .regularExpression) != nil}
        
        return Output(tap: input.tap,
                      validation: validation)
    }
}

// tap ->
// text -> validation,uicolor
