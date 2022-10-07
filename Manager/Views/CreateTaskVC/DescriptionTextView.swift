//
//  DescriptionTextView.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import Foundation
import UIKit
 
class DescriptionTextView: UITextView, UITextViewDelegate {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configure()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tag = 3
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = #colorLiteral(red: 0.9435634613, green: 0.9468396306, blue: 0.949968636, alpha: 1)
        font = UIFont.systemFont(ofSize: 17)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

