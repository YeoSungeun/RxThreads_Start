//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 여성은 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingTableViewCell"
    
    let backView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    var doneButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return view
    }()
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        return view
    }()
    let contentLabel = {
        let view = UILabel()
        return view
    }()
    

    var disposeBag = DisposeBag()

     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    private func configure() {
        addSubview(backView)
        backView.addSubview(doneButton)
        backView.addSubview(likeButton)
        backView.addSubview(contentLabel)
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView.snp.centerY)
            make.leading.equalTo(backView.snp.leading).offset(8)
            make.size.equalTo(40)
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(backView.snp.centerY)
            make.trailing.equalTo(backView.snp.trailing).inset(8)
            make.size.equalTo(40)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView.snp.centerY)
            make.leading.equalTo(doneButton.snp.trailing).offset(8)
            make.trailing.equalTo(likeButton.snp.leading).offset(-8)
            make.height.equalTo(44)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}



