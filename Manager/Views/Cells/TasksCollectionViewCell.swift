//
//  TasksCollectionViewCell.swift
//  Manager
//
//  Created by Pasha Khorenko on 06.05.2022.
//

import Foundation
import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    var titleLabel = CellTitleLabel()
    var firstDemarcationLine = DemarcationLine()
    var descriptionLabel = CellDescriptionLabel()
    var secondDemarcationLine = DemarcationLine()
    var timeIntervalLabel = CellTimeIntervalLabel()
    var completedButton = CompletedButton()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 15
//        contentView.layer.borderColor = UIColor.systemGray.cgColor
//        contentView.layer.borderWidth = 2
        
        addSubview(titleLabel)
        addSubview(firstDemarcationLine)
        addSubview(descriptionLabel)
        addSubview(secondDemarcationLine)
        addSubview(timeIntervalLabel)
        addSubview(completedButton)
    }
}


// MARK: - SetConstraints

extension TasksCollectionViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: firstDemarcationLine.bottomAnchor,constant: 5),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: secondDemarcationLine.topAnchor, constant: -5),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: completedButton.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 7),
            
            completedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            completedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            completedButton.widthAnchor.constraint(equalToConstant: 30),
            completedButton.heightAnchor.constraint(equalToConstant: 30),
            
            firstDemarcationLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            firstDemarcationLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            firstDemarcationLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            firstDemarcationLine.heightAnchor.constraint(equalToConstant: 2),
            
            secondDemarcationLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            secondDemarcationLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            secondDemarcationLine.bottomAnchor.constraint(equalTo: timeIntervalLabel.topAnchor, constant: -5),
            secondDemarcationLine.heightAnchor.constraint(equalToConstant: 2),
            
            timeIntervalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timeIntervalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timeIntervalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)
        ])
    }
}
