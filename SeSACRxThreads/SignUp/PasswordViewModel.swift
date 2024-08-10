//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel {
    struct Input {
        let text: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    struct Output {
        let validation: Observable<Bool>
        let validText: Observable<String>
        let nextTap: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8 }
        let validText = Observable.just("8자리 이상 입력하세요")
        
        return Output(validation: validation,
                      validText: validText,
                      nextTap: input.nextTap)
    }
    
}

// input
// 비번텍스트
// tap

// output
// 유효성결과
// discrptionText
// tap 인식?

// 색깔은 어떻게 하지 ?
