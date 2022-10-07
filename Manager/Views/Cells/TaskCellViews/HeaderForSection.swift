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
        label.textColor = #colorLiteral(red: 0, green: 0.392432034, blue: 0.4122602344, alpha: 1)
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
        addSubview(headerForSetion)
    }
    
    func setConstrains() {
        NSLayoutConstraint.activate([
            headerForSetion.topAnchor.constraint(equalTo: topAnchor),
            headerForSetion.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
    }
    
}
