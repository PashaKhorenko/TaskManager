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
    
    private let prioritySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Low", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "High", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Medium", at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: "Critical", at: 3, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let tasksCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 5, right: 0)
            return layout
        }()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.backgroundColor = .green
//        collectionView.layer.cornerRadius = 15
        collectionView.backgroundColor = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var tasksDictionary = [0: [Task](),
                           1: [Task](),
                           2: [Task](),
                           3: [Task]()] {
        didSet {
            storage.save(tasks: tasksDictionary[0]!, forKey: "low")
            storage.save(tasks: tasksDictionary[1]!, forKey: "medium")
            storage.save(tasks: tasksDictionary[2]!, forKey: "high")
            storage.save(tasks: tasksDictionary[3]!, forKey: "critical")
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tasksCollectionView.reloadData()
    }
    
    private func loadTasks() {
        let lowTasksArray = storage.load("low")
        let mediumTasksArray = storage.load("medium")
        let highTasksArray = storage.load("high")
        let criticalTasksArray = storage.load("critical")
        
        tasksDictionary[0] = lowTasksArray
        tasksDictionary[1] = mediumTasksArray
        tasksDictionary[2] = highTasksArray
        tasksDictionary[3] = criticalTasksArray
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
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Tasks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.folder"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(rightBarButtonTapped))
    }
    
    @objc private func rightBarButtonTapped() {
        let vc = CreateTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.9197917581, green: 0.9297400713, blue: 0.9295648932, alpha: 1)
        
//        view.addSubview(backgroundView)
//        backgroundView.addSubview(prioritySegmentedControl)
//        view.addSubview(prioritySegmentedControl)
        
        view.addSubview(tasksCollectionView)
        
        tasksCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        tasksCollectionView.register(HeaderForSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderForSection")
        
        self.prioritySegmentedControl.addTarget(self, action: #selector(changedPriority(_:)), for: .valueChanged)
    }
    
    @objc private func changedPriority(_ sender: UISegmentedControl) {
        self.tasksCollectionView.reloadData()
    }
    
    private func setDelegates() {
        tasksCollectionView.dataSource = self
        tasksCollectionView.delegate = self
    }
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        tasksDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
//
//        return tasksDictionary[priorityKey]!.count
//
        guard let count = tasksDictionary[section]?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TasksCollectionViewCell else { return UICollectionViewCell()}
        
//        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
//        let task = tasksDictionary[indexPath.section]?[indexPath.item]
        
        guard let task = tasksDictionary[indexPath.section]?[indexPath.item] else {
            return UICollectionViewCell()
        }

        let startDate = task.startDate
        let deadlineDate = task.deadLineDate

        let completionStatus = task.isCompleted
        let imageName = completionStatus ? "checkmark.circle" : "circle"
        let image = UIImage(systemName: imageName)

        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.description
        cell.timeIntervalLabel.text = "\(startDate) - \(deadlineDate)"
        cell.completedButton.setImage(image, for: .normal)
        cell.completedButton.tag = indexPath.item
        cell.completedButton.addTarget(self, action: #selector(changeStatus(_:)), for: .touchUpInside)

        if completionStatus == true {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4745098039, alpha: 1)
//            cell.contentView.backgroundColor = .white
        }

        return cell
        
//        let task = tasksDictionary[indexPath.section]?[indexPath.row]
//
//        cell.titleLabel.text = task?.title
//
//        return cell
        
    }
    
    @objc func changeStatus(_ sender: UIButton) {
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex        
        let completionStatus = tasksDictionary[priorityKey]![sender.tag].isCompleted
        
        tasksDictionary[priorityKey]![sender.tag].isCompleted = !completionStatus
        
        let task = tasksDictionary[priorityKey]![sender.tag]
        
        if completionStatus == true {
            tasksDictionary[priorityKey]!.remove(at: sender.tag)
            tasksDictionary[priorityKey]!.insert(task, at: 0)
        } else {
            tasksDictionary[priorityKey]!.remove(at: sender.tag)
            tasksDictionary[priorityKey]!.append(task)
        }
        
        self.tasksCollectionView.reloadData()
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    // Short pressure
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        showActionSheet(didSelectItemAt: indexPath)
        print(indexPath)
    }
    
    
    // Header for section CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var titleLabelText: String = ""
        
        switch indexPath.section {
        case 0:
            titleLabelText = "Tasks with Low Priority"
        case 1:
            titleLabelText = "Tasks with Medium Priority"
        case 2:
            titleLabelText = "Tasks with High Priority"
        case 3:
            titleLabelText = "Tasks with Critical Priority"
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
    
    //contextMenu for collectionView
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let sectionIndex = indexPaths.first?[0]
        let taskIndex = indexPaths.first?[1]
        
        guard sectionIndex != nil && taskIndex != nil else {
            return UIContextMenuConfiguration()
        }
        
        return UIContextMenuConfiguration(actionProvider:  { suggestedActions in
            return UIMenu(children: [
                UIAction(title: "Edit", image: UIImage(systemName: "highlighter")) { _ in
                    /* Implement the action. */
                    self.setupEditButton(sectionIndex!, taskIndex!)
                },
                UIAction(title: "Drag and Drop", image: UIImage(systemName: "arrow.triangle.branch"), handler: { _ in
                    /* Implement the action. */
                    self.setupDragAndDropButton(sectionIndex!, taskIndex!)
                }),
                UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    /* Implement the action. */
                    self.setupRemoveButton(sectionIndex!, taskIndex!)
                }
            ])
        })
    }
    
    
    func setupEditButton(_ sectionIndex: Int, _ taskIndex: Int) {
        let task = tasksDictionary[sectionIndex]?[taskIndex]
        
        print("Edit task with title \(task?.title ?? "––")")
    }
    
    func setupDragAndDropButton(_ sectionIndex: Int, _ taskIndex: Int) {
        let task = tasksDictionary[sectionIndex]?[taskIndex]
        
        print("Drag and Drop task with title \(task?.title ?? "––")")
    }
    
    func setupRemoveButton(_ sectionIndex: Int, _ taskIndex: Int) {
        let task = tasksDictionary[sectionIndex]?[taskIndex]
        
        print("Remove task with title \(task?.title ?? "––")")
        
        tasksDictionary[sectionIndex]?.remove(at: taskIndex)
    }
    
    
//    private func showActionSheet(didSelectItemAt indexPath: IndexPath) {
//        let alertController = UIAlertController(title: "Choose an action for this task", message: nil, preferredStyle: .actionSheet)
//
//        let editAction = UIAlertAction(title: "Edit Task", style: .default) { action in
//            self.setupEditTaskButtonForActionSheet(indexPath)
//        }
//        let deleteAction = UIAlertAction(title: "Delete Task", style: .destructive) { action in
//            self.setupDeleteTaskButtonForActionSheet(indexPath)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alertController.addAction(editAction)
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
    
//    private func setupEditTaskButtonForActionSheet(_ indexPath: IndexPath) {
//        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
//
//        let taskStartDateString = tasksDictionary[priorityKey]![indexPath.item].startDate
//        let taskDeadlineDateString = tasksDictionary[priorityKey]![indexPath.item].deadLineDate
//
//        let taskTitle = tasksDictionary[priorityKey]![indexPath.item].title
//        let taskStartDate = formatter.date(from: taskStartDateString)
//        let taskDeadlineDate = formatter.date(from: taskDeadlineDateString)
//        let taskPrioriry = tasksDictionary[priorityKey]![indexPath.item].priority
//        let taskDescription = tasksDictionary[priorityKey]![indexPath.item].description
//        let isCompleted = tasksDictionary[priorityKey]![indexPath.item].isCompleted
//
//        let createTaskVC = CreateTaskViewController()
//
//        createTaskVC.taskTitleTextField.text = taskTitle
//        createTaskVC.startDatePicker.date = taskStartDate ?? .now
//        createTaskVC.deadlineDatePicker.date = taskDeadlineDate ?? .now
//        createTaskVC.prioritySegmentedControl.selectedSegmentIndex = taskPrioriry
//        createTaskVC.descriptionTextView.text = taskDescription
//
//        createTaskVC.isCompleted = isCompleted
//        createTaskVC.priorityKeyForEditing = priorityKey
//        createTaskVC.indexPathForEditing = indexPath.item
//        createTaskVC.createTaskButton.tag = 2
//
//        self.navigationController?.pushViewController(createTaskVC, animated: true)
//    }
    
//    private func setupDeleteTaskButtonForActionSheet(_ indexPath: IndexPath) {
//        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
//
//        tasksDictionary[priorityKey]!.remove(at: indexPath.item)
//
//        self.collectionView.reloadData()
//    }
    
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
//            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            prioritySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            tasksCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tasksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tasksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tasksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

