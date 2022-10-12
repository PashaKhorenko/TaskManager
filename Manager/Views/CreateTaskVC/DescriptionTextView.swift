//
//  DescriptionTextView.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

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
        layer.masksToBounds = true
        layer.cornerRadius = 10
        backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        font = UIFont.systemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

