//
//  CellDescriptionLabel.swift
//  Manager
//
//  Created by Pasha Khorenko on 08.05.2022.
//

import Foundation
import UIKit

class CellDescriptionLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont(name: "HelveticaNeue", size: 17)
        text = "Test Description Test Description Test Description"
        numberOfLines = 4
        translatesAutoresizingMaskIntoConstraints = false
    }
}
