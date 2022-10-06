//
//  DemarcationLine.swift
//  Manager
//
//  Created by Pasha Khorenko on 08.05.2022.
//

import Foundation
import UIKit

class DemarcationLine: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.3215686275, blue: 0.337254902, alpha: 1)
        layer.cornerRadius = self.frame.height / 2.5
        translatesAutoresizingMaskIntoConstraints = false
    }
}
