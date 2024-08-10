//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    struct Output {
        let nicknameText: ControlProperty<String>
        let nextTap: ControlEvent<Void>
        
    }
    func transform(input: Input) -> Output {
        
        return Output(nicknameText: input.nicknameText.orEmpty,
                      nextTap: input.nextTap)
    }
}
