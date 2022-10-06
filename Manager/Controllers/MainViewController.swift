//
//  ViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 20.03.2022.
//

import UIKit
import AVFoundation
import AudioToolbox

class MainViewController: UIViewController {
    
    private let tasksCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 5, right: 0)
            return layout
        }()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    var tasksDictionary: [Int: [Task]] = [0: [Task](),
                                          1: [Task](),
                                          2: [Task](),
                                          3: [Task]()] {
        didSet {
            storage.save(tasks: tasksDictionary[0]!, forKey: "critical")
            storage.save(tasks: tasksDictionary[1]!, forKey: "high")
            storage.save(tasks: tasksDictionary[2]!, forKey: "medium")
            storage.save(tasks: tasksDictionary[3]!, forKey: "low")
            
            self.tasksCollectionView.reloadData()
        }
    }
    
    var storage: TaskStorageProtocol!
    
    // MARK: - Live Circle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupViews()
        setConstreints()
        setDelegates()
        
        storage = TaskStorage()
        
        loadTasks()
        // Drag & Drop
//        let longPressGesture = UILongPressGestureRecognizer(
//            target: self,
//            action: #selector(handleLongPressGesture)
//        )
//        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func loadTasks() {
        let criticalTasksArray = storage.load("critical")
        let highTasksArray = storage.load("high")
        let mediumTasksArray = storage.load("medium")
        let lowTasksArray = storage.load("low")
        
        if !lowTasksArray.isEmpty {
            tasksDictionary[0] = criticalTasksArray
        }
        if !mediumTasksArray.isEmpty {
            tasksDictionary[1] = highTasksArray
        }
        if !highTasksArray.isEmpty {
            tasksDictionary[2] = mediumTasksArray
        }
        if !criticalTasksArray.isEmpty {
            tasksDictionary[3] = lowTasksArray
        }
    }
    
    
    // MARK: ----------------------------
    
    // Drag & Drop
//    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
//
//        let gestureLocation = gesture.location(in: collectionView)
//
//        switch gesture.state {
//        case .began:
//
//            AudioServicesPlaySystemSound(SystemSoundID(1004))
//
//            guard let targetIndexPath = collectionView.indexPathForItem(at: gestureLocation) else {
//                return
//            }
//            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
//        case .changed:
//            collectionView.updateInteractiveMovementTargetPosition(gestureLocation)
//        case .ended:
//            AudioServicesPlaySystemSound(SystemSoundID(1003))
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }
    
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.6648817658, green: 0.7693511844, blue: 0.7778732181, alpha: 1)
        
        view.addSubview(tasksCollectionView)
        
        tasksCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        tasksCollectionView.register(HeaderForSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderForSection")
        
    }
    
    private func setDelegates() {
        tasksCollectionView.dataSource = self
        tasksCollectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Tasks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.folder"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.01568627451, green: 0.3215686275, blue: 0.337254902, alpha: 1)
    }
    
    @objc private func rightBarButtonTapped() {
        self.navigationController?.pushViewController(CreateTaskViewController(), animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        tasksDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = tasksDictionary[section]?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TasksCollectionViewCell,
              let task = tasksDictionary[indexPath.section]?[indexPath.item] else { return UICollectionViewCell()}
        
#warning("attributedText")
        let attributedForCompleted = NSAttributedString(string: task.title,
                                                        attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        let attributedForNotCompleted = NSAttributedString(string: task.title,
                                                           attributes: [.strikethroughStyle:
                                                                            NSUnderlineStyle.patternDot.rawValue])
        
        cell.titleLabel.attributedText = task.isCompleted ? attributedForCompleted : attributedForNotCompleted
//        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        cell.timeIntervalLabel.text = task.deadLineDate

        cell.titleLabel.textColor = task.isCompleted ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        cell.descriptionLabel.textColor = task.isCompleted ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        cell.timeIntervalLabel.textColor = task.isCompleted ? #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1)
        cell.contentView.backgroundColor = task.isCompleted ? #colorLiteral(red: 0.031165611, green: 0.08367796987, blue: 0.08724553138, alpha: 1) : #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1)

        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    // Short pressure
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupEditButton(indexPath.section, indexPath.item)
    }
    
    
    // Header for section CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var titleLabelText: String = ""
        
        switch indexPath.section {
        case 0:
            titleLabelText = "Tasks with Critical Priority"
        case 1:
            titleLabelText = "Tasks with High Priority"
        case 2:
            titleLabelText = "Tasks with Medium Priority"
        case 3:
            titleLabelText = "Tasks with Low Priority"
        default:
            titleLabelText = "Another Priority"
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderForSection", for: indexPath) as! HeaderForSection
            
            headerView.headerForSetion.text = titleLabelText
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // Size for header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 20)
    }
    
    //MARK: UIContextMenu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let sectionIndex = indexPaths.first?[0]
        let taskIndex = indexPaths.first?[1]
        
        guard sectionIndex != nil && taskIndex != nil else {
            return UIContextMenuConfiguration()
        }
        
        let taskIsCompleted = tasksDictionary[sectionIndex!]?[taskIndex!].isCompleted
        let completedButtonTitle = taskIsCompleted! ? "Not Completed" : "Completed"
        
        return UIContextMenuConfiguration(actionProvider:  { [weak self] suggestedActions in
            return UIMenu(children: [
                UIAction(title: completedButtonTitle, image: UIImage(systemName: "app.badge.checkmark")) { [weak self] _ in
                    self?.setupCompletedButton(sectionIndex!, taskIndex!)
                },
                UIAction(title: "Edit", image: UIImage(systemName: "highlighter")) { [weak self] _ in
                    self?.setupEditButton(sectionIndex!, taskIndex!)
                },
                UIAction(title: "Drag and Drop", image: UIImage(systemName: "arrow.triangle.branch"), handler: { [weak self] _ in
                    self?.setupDragAndDropButton(sectionIndex!, taskIndex!)
                }),
                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.setupDeleteButton(sectionIndex!, taskIndex!)
                }
            ])
        })
    }
    
    func setupCompletedButton(_ sectionIndex: Int, _ taskIndex: Int) {
        guard let isCompletedOldValue = tasksDictionary[sectionIndex]?[taskIndex].isCompleted else { return }
        tasksDictionary[sectionIndex]?[taskIndex].isCompleted = !isCompletedOldValue
    }
    
    func setupEditButton(_ sectionIndex: Int, _ taskIndex: Int) {
        guard let task = tasksDictionary[sectionIndex]?[taskIndex] else { return }
        let createTaskVC = CreateTaskViewController()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        createTaskVC.taskTitleTextField.text = task.title
        createTaskVC.deadlineDatePicker.date = formatter.date(from: task.deadLineDate) ?? .now
        createTaskVC.prioritySegmentedControl.selectedSegmentIndex = sectionIndex
        createTaskVC.descriptionTextView.text = task.description
        createTaskVC.isCompleted = task.isCompleted
        createTaskVC.priorityKeyForEditing = sectionIndex
        createTaskVC.indexPathForEditing = taskIndex
        createTaskVC.createTaskButton.tag = 2
        
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func setupDragAndDropButton(_ sectionIndex: Int, _ taskIndex: Int) {
        #warning("Реалізувати перетягування комірки на інше довільне місце")
        guard let task = tasksDictionary[sectionIndex]?[taskIndex] else { return }
        print("Drag and Drop task with title \(task.title)")
    }
    
    func setupDeleteButton(_ sectionIndex: Int, _ taskIndex: Int) {
        let alertController = UIAlertController(title: "Confirm the deletion",
                                                message: "If you press the \"Delete\" button, this action cannot be undone.",
                                                preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.tasksDictionary[sectionIndex]?.remove(at: taskIndex)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        alertController.addAction(deleteButton)
        
        present(alertController, animated: true)
    }
    
    // Long pressure (drag & drop)
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
//
//        let task = tasksDictionary[priorityKey]!.remove(at: sourceIndexPath.item)
//        tasksDictionary[priorityKey]!.insert(task, at: destinationIndexPath.item)
//    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    // размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let paddingWidth = 20 * (itemsPerRow + 1)
//        let aveilebleWidth = collectionView.frame.width - paddingWidth
//        let widthPerItem = aveilebleWidth / itemsPerRow
        
        CGSize(width: collectionView.bounds.width - 20,
               height: collectionView.bounds.width / 2)
    }
}


// MARK: - Constraints

extension MainViewController {
    private func setConstreints() {
        NSLayoutConstraint.activate([
            tasksCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tasksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tasksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tasksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

