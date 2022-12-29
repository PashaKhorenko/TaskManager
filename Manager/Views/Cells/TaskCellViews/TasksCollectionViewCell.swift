//
//  TasksCollectionViewCell.swift
//  Manager
//
//  Created by Pasha Khorenko on 06.05.2022.
//

import UIKit

class TasksCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var dateOfCreationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let firstDemarcationLine = DemarcationLine()
    private let secondDemarcationLine = DemarcationLine()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setConstraints()
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
        addSubview(dateOfCreationLabel)
        addSubview(deadlineLabel)
    }
    
    private func getDataFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        return formatter
    }
    
    private func configuteColors(_ completionStatus: Bool) {
        titleLabel.textColor = completionStatus ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        descriptionLabel.textColor = completionStatus ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        dateOfCreationLabel.textColor = completionStatus ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        deadlineLabel.textColor = completionStatus ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        contentView.backgroundColor = completionStatus ? #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1) : #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1)
    }
    
    func configure(for task: Task) {
        let formatter = getDataFormatter()
        
        configuteColors(task.completionStatus)
        
        titleLabel.text = task.title
        descriptionLabel.text = task.descriptionText
        dateOfCreationLabel.text = "Date of creation: \(formatter.string(from: task.dateOfCreation!))"
        deadlineLabel.text = "Deadline: \(formatter.string(from: task.deadlineDate!))"
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
            secondDemarcationLine.bottomAnchor.constraint(equalTo: dateOfCreationLabel.topAnchor, constant: -5),
            secondDemarcationLine.heightAnchor.constraint(equalToConstant: 2),

            dateOfCreationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateOfCreationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateOfCreationLabel.bottomAnchor.constraint(equalTo: deadlineLabel.topAnchor),
            
            deadlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            deadlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            deadlineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
