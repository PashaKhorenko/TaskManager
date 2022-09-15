//
//  PrioritySegmentedControl.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import Foundation
import UIKit

class PrioritySegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        insertSegment(withTitle: "Low", at: 0, animated: true)
        insertSegment(withTitle: "Medium", at: 1, animated: true)
        insertSegment(withTitle: "High", at: 2, animated: true)
        insertSegment(withTitle: "Critical", at: 3, animated: true)
        
        selectedSegmentIndex = 0
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
