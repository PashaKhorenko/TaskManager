//
//  TitleLabel.swift
//  Manager
//
//  Created by Pasha Khorenko on 08.05.2022.
//

import Foundation
import UIKit

class CellTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        text = "Test title"
        translatesAutoresizingMaskIntoConstraints = false
    }
}
