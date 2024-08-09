//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/5/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ShoppingItem {
    let title: String
    var isDone = false
    var isLiked = false
}

class ShoppingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 60
        view.separatorStyle = .none
        return view
    }()
    private let addListView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    private let addListTextField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실 건가요?"
        return view
    }()
    private let addListButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray3
        return view
    }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    var data = [ShoppingItem(title: "이것저것"), ShoppingItem(title: "펜 리필심 사기"), ShoppingItem(title: "안경 맞추기")]
    lazy var list = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(addListView)
        addListView.addSubview(addListTextField)
        addListView.addSubview(addListButton)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(44)
        }
        addListView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(80)
        }
        addListButton.snp.makeConstraints { make in
            make.centerY.equalTo(addListView.snp.centerY)
            make.trailing.equalTo(addListView.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
            make.width.equalTo(50)
        }
        addListTextField.snp.makeConstraints { make in
            make.centerY.equalTo(addListView.snp.centerY)
            make.leading.equalTo(addListView.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(addListButton.snp.leading).inset(16)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addListView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    private func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                cell.contentLabel.text = element.title
                let doneImage = element.isDone ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
                cell.doneButton.setImage(doneImage, for: .normal)
                
                let likeImage = element.isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                cell.likeButton.setImage(likeImage, for: .normal)
                
                cell.doneButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print("doneButton clicked")
                        owner.data[row].isDone.toggle()
                        owner.list.onNext(owner.data)
                    }
                    .disposed(by: cell.disposeBag)
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print("likeButton clicked")
                        owner.data[row].isLiked.toggle()
                        owner.list.onNext(owner.data)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        addListButton.rx.tap
            .withLatestFrom(addListTextField.rx.text.orEmpty) { void, text in
                return text
            }
            .bind(with: self) { owner, value in
                owner.data.insert(ShoppingItem(title: value), at: 0)
                owner.list.onNext(owner.data)
                owner.addListTextField.rx.text.onNext(nil)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter {
                    $0.title.contains(value.uppercased())
                }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}
