//
//  CompletedButton.swift
//  Manager
//
//  Created by Pasha Khorenko on 16.05.2022.
//

import UIKit

class CompletedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tintColor = .gray
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        translatesAutoresizingMaskIntoConstraints = false
    }
}
