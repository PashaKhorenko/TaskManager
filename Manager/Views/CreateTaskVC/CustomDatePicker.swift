//
//  CustomDatePicker.swift
//  Manager
//
//  Created by Паша Хоренко on 06.10.2022.
//

import UIKit

class CustomDatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        datePickerMode = .dateAndTime
        locale = Locale(identifier: "en_UA")
        translatesAutoresizingMaskIntoConstraints = false
    }
}
