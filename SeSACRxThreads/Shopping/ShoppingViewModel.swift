//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {

    struct Input {
        let searchText: ControlProperty<String?>
        let addText: ControlProperty<String?>
        let addListTap: ControlEvent<Void>
    }
    struct Output {
        var list: BehaviorSubject<[ShoppingItem]>
        var addListTap: ControlEvent<Void>
    }
    
    var data = [ShoppingItem(title: "이것저것"), ShoppingItem(title: "펜 리필심 사기"), ShoppingItem(title: "안경 맞추기")]
    lazy var list = BehaviorSubject(value: data)
    let disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        
        input.addListTap
            .withLatestFrom(input.addText.orEmpty)
            .subscribe(with: self) { owner, value in
                owner.data.insert(ShoppingItem(title: value), at: 0)
                owner.list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.searchText.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter {
                    $0.title.contains(value.uppercased())
                }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
        
        input.searchText.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter {
                    $0.title.contains(value.uppercased())
                }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
            
        return Output(list: list, 
                      addListTap: input.addListTap)
    }
}

