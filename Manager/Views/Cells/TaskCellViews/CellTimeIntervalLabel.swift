//
//  CellTimeIntervalLabel.swift
//  Manager
//
//  Created by Pasha Khorenko on 08.05.2022.
//

import Foundation
import UIKit

class CellTimeIntervalLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont(name: "HelveticaNeue", size: 16)
        text = "Test TimeInterval"
        translatesAutoresizingMaskIntoConstraints = false
    }
}
