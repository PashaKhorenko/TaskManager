//
//  ViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 20.03.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
    
    let notifications = Notifications()
    
    // MARK: - UI Elements
    private let prioritySegmentedControl = PrioritySegmentedControl(frame: .zero)
      
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let criticalTaskCollectionView = TaskCollectionView(frame: .zero,
                                                                collectionViewLayout: UICollectionViewFlowLayout())
    private let highTaskCollectionView = TaskCollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout())
    private let mediumTaskCollectionView = TaskCollectionView(frame: .zero,
                                                              collectionViewLayout: UICollectionViewFlowLayout())
    private let lowTaskCollectionView = TaskCollectionView(frame: .zero,
                                                           collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Data
    
    private var tasksArray: [Task] = []
    
    private var criticalTasksArray: [Task] = []
    private var highTasksArray: [Task] = []
    private var mediumTasksArray: [Task] = []
    private var lowTasksArray: [Task] = []
    
    private func arrayFilling() {
        criticalTasksArray = tasksArray.filter({ $0.priority == 0 })
        highTasksArray = tasksArray.filter({ $0.priority == 1 })
        mediumTasksArray = tasksArray.filter({ $0.priority == 2 })
        lowTasksArray = tasksArray.filter({ $0.priority == 3 })
    }
    
    // MARK: - Auxiliary functions
    
    private func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = getAppDelegate()
        
        return appDelegate.persistentContainer.viewContext
    }
    
    private func getSortingConditions() -> [NSSortDescriptor] {
        let sortByDate = NSSortDescriptor(key: "dateOfCreation", ascending: false)
        let sortByCompletion = NSSortDescriptor(key: "completionStatus", ascending: true)
        
        return [sortByCompletion, sortByDate]
    }
    
    private func getDataFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        return formatter
    }
    
    // MARK: - Live Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupViews()
        delegatesSetup()
        dataSourceSetup()
        setConstreints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest = Task.fetchRequest()
        
        fetchRequest.sortDescriptors = getSortingConditions()
        
        do {
            tasksArray = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        arrayFilling()
        
        self.criticalTaskCollectionView.reloadData()
        self.highTaskCollectionView.reloadData()
        self.mediumTaskCollectionView.reloadData()
        self.lowTaskCollectionView.reloadData()
    }
    
    // MARK: - Views Settings
    
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.6648817658, green: 0.7693511844, blue: 0.7778732181, alpha: 1)
        
        view.addSubview(prioritySegmentedControl)
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(criticalTaskCollectionView)
        stackView.addArrangedSubview(highTaskCollectionView)
        stackView.addArrangedSubview(mediumTaskCollectionView)
        stackView.addArrangedSubview(lowTaskCollectionView)
        
        registerUICollectionViewCells()
        
        prioritySegmentedControl.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
    }
    
    private func registerUICollectionViewCells() {
        self.criticalTaskCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "CriticalTaskCollectionViewCell")
        self.highTaskCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "HighTaskCollectionViewCell")
        self.mediumTaskCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "MediumTaskCollectionViewCell")
        self.lowTaskCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "LowTaskCollectionViewCell")
    }
    
    private func delegatesSetup() {
        self.scrollView.delegate = self
        
        self.criticalTaskCollectionView.delegate = self
        self.highTaskCollectionView.delegate = self
        self.mediumTaskCollectionView.delegate = self
        self.lowTaskCollectionView.delegate = self
    }
    
    private func dataSourceSetup() {
        self.criticalTaskCollectionView.dataSource = self
        self.highTaskCollectionView.dataSource = self
        self.mediumTaskCollectionView.dataSource = self
        self.lowTaskCollectionView.dataSource = self
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
    
    // MARK: - @objc func
    
    @objc private func rightBarButtonTapped() {
        self.navigationController?.pushViewController(CreateTaskViewController(), animated: true)
    }
    
    @objc private func priorityChanged(_ sender: UISegmentedControl) {
        let xOffset = scrollView.bounds.width * CGFloat(sender.selectedSegmentIndex)
        scrollView.setContentOffset(CGPointMake(xOffset,0), animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case criticalTaskCollectionView: return criticalTasksArray.count
        case highTaskCollectionView: return highTasksArray.count
        case mediumTaskCollectionView: return mediumTasksArray.count
        default: return lowTasksArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = TasksCollectionViewCell()
        
        switch collectionView {
        case criticalTaskCollectionView:
            cell = cellConfigure(withId: "CriticalTaskCollectionViewCell", indexPath: indexPath, data: criticalTasksArray, for: collectionView)
        case highTaskCollectionView:
            cell = cellConfigure(withId: "HighTaskCollectionViewCell", indexPath: indexPath, data: highTasksArray, for: collectionView)
        case mediumTaskCollectionView:
            cell = cellConfigure(withId: "MediumTaskCollectionViewCell", indexPath: indexPath, data: mediumTasksArray, for: collectionView)
        case lowTaskCollectionView:
            cell = cellConfigure(withId: "LowTaskCollectionViewCell", indexPath: indexPath, data: lowTasksArray, for: collectionView)
        default:
            print("")
            
        }
        
        return cell
    }
    
    private func cellConfigure(withId id: String, indexPath: IndexPath, data: [Task], for collectionView: UICollectionView) -> TasksCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! TasksCollectionViewCell
        
        cell.configure(for: data[indexPath.item])
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    
    // Short pressure
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setupEditButton(indexPath.item)
    }
    
    // MARK: UIContextMenu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {

        let taskIndex = indexPaths.first?[1]

        guard let taskIndex else {
            return UIContextMenuConfiguration()
        }
        
        var taskCompletion: Bool {
            switch prioritySegmentedControl.selectedSegmentIndex {
            case 0: return criticalTasksArray[taskIndex].completionStatus
            case 1: return highTasksArray[taskIndex].completionStatus
            case 2: return mediumTasksArray[taskIndex].completionStatus
            default: return lowTasksArray[taskIndex].completionStatus
            }
        }
        let completedButtonTitle = taskCompletion ? "Not Completed" : "Completed"
        
        return UIContextMenuConfiguration(actionProvider:  { [weak self] suggestedActions in
            return UIMenu(children: [
                
                UIAction(title: completedButtonTitle,
                         image: UIImage(systemName: "app.badge.checkmark"),
                         handler: { [weak self] _ in
                             self?.setupCompletedButton(taskIndex)
                         }),
                
                UIAction(title: "Edit",
                         image: UIImage(systemName: "highlighter"),
                         handler: { [weak self] _ in
                             self?.setupEditButton(taskIndex)
                         }),
                
                UIAction(title: "Delete",
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive,
                         handler: { [weak self] _ in
                             self?.setupDeleteButton(taskIndex)
                         })
            ])
        })
    }
}

// Customizing buttons for UIContextMenu
extension MainViewController {
    
    // MARK: Completed Button
    private func setupCompletedButton(_ taskIndex: Int) {
        let formatter = getDataFormatter()
        
        func editTask(in array: [Task]) {
            if !array[taskIndex].completionStatus {
                let completedAt = "Marked as completed on \(formatter.string(from: .now))."
                let description = array[taskIndex].descriptionText
                
                array[taskIndex].descriptionText = "\(completedAt) \n\(description!)"
                
                let notificationID = "\(array[taskIndex].dateOfCreation!)"
                
                self.notifications.remove(with: [notificationID])
            } else {
                self.notifications.sentNotification(for: array[taskIndex])
            }
        
            array[taskIndex].completionStatus.toggle()
        }
        
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0: editTask(in: criticalTasksArray)
        case 1: editTask(in: highTasksArray)
        case 2: editTask(in: mediumTasksArray)
        default: editTask(in: lowTasksArray)
        }
        
        let context = getContext()
        
        do {
            try context.save()
            self.criticalTaskCollectionView.reloadData()
            self.highTaskCollectionView.reloadData()
            self.mediumTaskCollectionView.reloadData()
            self.lowTaskCollectionView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Edit Button
    private func setupEditButton(_ taskIndex: Int) {
        var task: Task {
            switch prioritySegmentedControl.selectedSegmentIndex {
            case 0: return criticalTasksArray[taskIndex]
            case 1: return highTasksArray[taskIndex]
            case 2: return mediumTasksArray[taskIndex]
            default: return lowTasksArray[taskIndex]
            }
        }
        let createTaskVC = CreateTaskViewController()
        
        createTaskVC.taskTitleTextField.text = task.title
        createTaskVC.deadlineDatePicker.date = task.deadlineDate!
        createTaskVC.prioritySegmentedControl.selectedSegmentIndex = Int(task.priority)
        createTaskVC.descriptionTextView.text = task.descriptionText
        createTaskVC.isCompleted = task.completionStatus
        
        createTaskVC.notificationID = task.dateOfCreation!
        createTaskVC.priorityKeyForEditing = Int(task.priority)
        createTaskVC.indexPathForEditing = taskIndex
        
        createTaskVC.createTaskButton.tag = 2
        
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    // MARK: Delete Button
    private func setupDeleteButton(_ taskIndex: Int) {
        let alertController = UIAlertController(title: "Confirm the deletion",
                                                message: "If you press the \"Delete\" button, this action cannot be undone.",
                                                preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            let context = self.getContext()
            let fetchRequest = Task.fetchRequest()
            
            fetchRequest.sortDescriptors = self.getSortingConditions()
            
            guard let array = try? context.fetch(fetchRequest) else { return }
            
            // Deleting notification request
            let notificationID = array[taskIndex].dateOfCreation
            self.notifications.remove(with: ["\(notificationID!)"])
            
            // Deleting task on storage context
            context.delete(array[taskIndex])
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            // Deleting task on UI
            switch self.prioritySegmentedControl.selectedSegmentIndex {
            case 0:
                self.criticalTasksArray.remove(at: taskIndex)
                self.criticalTaskCollectionView.reloadData()
            case 1:
                self.highTasksArray.remove(at: taskIndex)
                self.highTaskCollectionView.reloadData()
            case 2:
                self.mediumTasksArray.remove(at: taskIndex)
                self.mediumTaskCollectionView.reloadData()
            default:
                self.lowTasksArray.remove(at: taskIndex)
                self.lowTaskCollectionView.reloadData()
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        alertController.addAction(deleteButton)
        
        present(alertController, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // Сell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        
        let widthPerItem = availableWidth / itemsPerRow
        let heigthPerItem = widthPerItem / 2
        
        return CGSize(width: widthPerItem, height: heigthPerItem)
    }
    
    // Indent the section outward
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    // Indentation within a section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        prioritySegmentedControl.selectedSegmentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}


// MARK: - Constraints

extension MainViewController {
    private func setConstreints() {
        NSLayoutConstraint.activate([
            prioritySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            criticalTaskCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            highTaskCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mediumTaskCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lowTaskCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
}
