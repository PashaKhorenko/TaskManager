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
    
    private let backgroundView = BackgroundForSegmentedControl()
    private let prioritySegmentedControl = PrioritySegmentedControl(frame: CGRect(x: 0,
                                                                                  y: 0,
                                                                                  width: 0,
                                                                                  height: 0))
    private let collectionView = TasksCollectionView(frame: .zero,
                                                     collectionViewLayout: UICollectionViewFlowLayout())
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 20,
                                              left: 20,
                                              bottom: 20,
                                              right: 20)
    
    var tasksDictionary = [0: [Task](),
                           1: [Task](),
                           2: [Task](),
                           3: [Task]()] {
        didSet {
            storage.save(tasks: tasksDictionary[0]!, forKey: "low")
            storage.save(tasks: tasksDictionary[1]!, forKey: "medium")
            storage.save(tasks: tasksDictionary[2]!, forKey: "high")
            storage.save(tasks: tasksDictionary[3]!, forKey: "critical")
        }
    }
    
    var storage: TaskStorageProtocol!
    
    // MARK: - Live Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
                
        setupNavigationBar()
        setupViews()
        setConstreints()
        setDelegates()
        
        storage = TaskStorage()
        loadTasks()
        
        // Drag & Drop
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture)
        )
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
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
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        let gestureLocation = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began:
            
            AudioServicesPlaySystemSound(SystemSoundID(1004))
            
            guard let targetIndexPath = collectionView.indexPathForItem(at: gestureLocation) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gestureLocation)
        case .ended:
            AudioServicesPlaySystemSound(SystemSoundID(1003))
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
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
        view.addSubview(backgroundView)
        backgroundView.addSubview(prioritySegmentedControl)
        view.addSubview(collectionView)
        
        self.prioritySegmentedControl.addTarget(self, action: #selector(changedPriority(_:)), for: .valueChanged)
    }
    
    @objc private func changedPriority(_ sender: UISegmentedControl) {
        self.collectionView.reloadData()
    }
    
    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
        
        return tasksDictionary[priorityKey]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdCell.idTaskCell.rawValue, for: indexPath) as? TasksCollectionViewCell else { return UICollectionViewCell()}
        
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
        let task = tasksDictionary[priorityKey]![indexPath.item]
        
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
        }
        
        return cell
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
        
        self.collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    // Short pressure
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showActionSheet(didSelectItemAt: indexPath)
    }
    
    private func showActionSheet(didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Choose an action for this task", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit Task", style: .default) { action in
            self.setupEditTaskButtonForActionSheet(indexPath)
        }
        let deleteAction = UIAlertAction(title: "Delete Task", style: .destructive) { action in
            self.setupDeleteTaskButtonForActionSheet(indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupEditTaskButtonForActionSheet(_ indexPath: IndexPath) {
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        let taskStartDateString = tasksDictionary[priorityKey]![indexPath.item].startDate
        let taskDeadlineDateString = tasksDictionary[priorityKey]![indexPath.item].deadLineDate
        
        let taskTitle = tasksDictionary[priorityKey]![indexPath.item].title
        let taskStartDate = formatter.date(from: taskStartDateString)
        let taskDeadlineDate = formatter.date(from: taskDeadlineDateString)
        let taskPrioriry = tasksDictionary[priorityKey]![indexPath.item].priority
        let taskDescription = tasksDictionary[priorityKey]![indexPath.item].description
        let isCompleted = tasksDictionary[priorityKey]![indexPath.item].isCompleted
                
        let createTaskVC = CreateTaskViewController()
        
        createTaskVC.taskTitleTextField.text = taskTitle
        createTaskVC.startDatePicker.date = taskStartDate ?? .now
        createTaskVC.deadlineDatePicker.date = taskDeadlineDate ?? .now
        createTaskVC.prioritySegmentedControl.selectedSegmentIndex = taskPrioriry
        createTaskVC.descriptionTextView.text = taskDescription
        
        createTaskVC.isCompleted = isCompleted
        createTaskVC.priorityKeyForEditing = priorityKey
        createTaskVC.indexPathForEditing = indexPath.item
        createTaskVC.createTaskButton.tag = 2
        
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    private func setupDeleteTaskButtonForActionSheet(_ indexPath: IndexPath) {
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
        
        tasksDictionary[priorityKey]!.remove(at: indexPath.item)
        
        self.collectionView.reloadData()
    }
    
    // Long pressure (drag & drop)
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let priorityKey = prioritySegmentedControl.selectedSegmentIndex
        
        let task = tasksDictionary[priorityKey]!.remove(at: sourceIndexPath.item)
        tasksDictionary[priorityKey]!.insert(task, at: destinationIndexPath.item)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    // размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let aveilebleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = aveilebleWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem / 2)
    }
    
    // внешние стступы секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    // отступы внутри секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
}


// MARK: - Constraints

extension MainViewController {
    
    private func setConstreints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            prioritySegmentedControl.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}



// code 1

// code 2
