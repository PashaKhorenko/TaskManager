//
//  StartDatePicker.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import Foundation
import UIKit

class StartDatePicker: UIDatePicker {
    
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
