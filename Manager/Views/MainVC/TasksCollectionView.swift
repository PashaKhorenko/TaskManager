//
//  TasksCollectionView.swift
//  Manager
//
//  Created by Pasha Khorenko on 06.05.2022.
//

import UIKit

enum IdCell: String {
    case idTaskCell
}

// MARK: - UICollectionView

class TasksCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()

        register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: IdCell.idTaskCell.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .none
        
        delegate = self
    }
}


// MARK: - UICollectionViewDelegate

extension TasksCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

