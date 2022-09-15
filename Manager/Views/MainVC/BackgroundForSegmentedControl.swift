//
//  BackgroundForSegmentedControl.swift
//  Manager
//
//  Created by Pasha Khorenko on 06.05.2022.
//

import UIKit

class BackgroundForSegmentedControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = #colorLiteral(red: 0.3725490196, green: 0.8156862745, blue: 0.7803921569, alpha: 1)
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
