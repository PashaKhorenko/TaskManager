//
//  TaskTitleTextField.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

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
        placeholder = "Enter short title"
        font = UIFont(name: "HelveticaNeue", size: 18)
        layer.masksToBounds = true
        layer.cornerRadius = 10
        textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        clearButtonMode = .whileEditing
        returnKeyType = .done
        borderStyle = .roundedRect
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension TaskTitleTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
    }
}
