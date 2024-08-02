//
//  SignTextField.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

class SignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        textColor = Color.black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Color.black.cgColor
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

