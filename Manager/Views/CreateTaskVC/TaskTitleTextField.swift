//
//  TaskTitleTextField.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import Foundation
import UIKit

class TaskTitleTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tag = 4
        placeholder = "Enter short title"
        font = UIFont(name: "HelveticaNeue", size: 17)
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = #colorLiteral(red: 0.9435634613, green: 0.9468396306, blue: 0.949968636, alpha: 1)
        clearButtonMode = .whileEditing
        borderStyle = .roundedRect
        returnKeyType = .done
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension TaskTitleTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
    }
}
