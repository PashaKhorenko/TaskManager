//
//  HeaderForSection.swift
//  Manager
//
//  Created by Паша Хоренко on 01.10.2022.
//

import UIKit

class HeaderForSection: UICollectionReusableView {
    
    let headerForSetion: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        label.textColor = .secondaryLabel
//        label.backgroundColor = .yellow
        label.text = "Tasks with Low Prioriti"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Customize here
        setupViews()
        setConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
//        backgroundColor = UIColor.purple
        addSubview(headerForSetion)
    }
    
    func setConstrains() {
        NSLayoutConstraint.activate([
            headerForSetion.topAnchor.constraint(equalTo: topAnchor),
            headerForSetion.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
    }
    
}
