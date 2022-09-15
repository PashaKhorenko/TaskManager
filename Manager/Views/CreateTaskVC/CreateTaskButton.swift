//
//  CreateTaskButton.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import Foundation
import UIKit

class CreateTaskButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func configure() {
        tag = 1
        setTitle("Create Task", for: .normal)
        backgroundColor = .systemBlue
        tintColor = .white
        layer.cornerRadius = 10
        titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
