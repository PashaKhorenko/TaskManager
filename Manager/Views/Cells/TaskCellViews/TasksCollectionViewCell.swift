//
//  TasksCollectionViewCell.swift
//  Manager
//
//  Created by Pasha Khorenko on 06.05.2022.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "descriptionLabel TEXT"
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var timeIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "timeIntervalLabel TEXT"
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let firstDemarcationLine = DemarcationLine()
    let secondDemarcationLine = DemarcationLine()
        
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
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 3.5
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        
        addSubview(titleLabel)
        addSubview(firstDemarcationLine)
        addSubview(descriptionLabel)
        addSubview(secondDemarcationLine)
        addSubview(timeIntervalLabel)
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
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

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
