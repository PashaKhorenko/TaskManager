//
//  ViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 20.03.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    let notifications = Notifications()
    
    private let prioritySegmentedControl = PrioritySegmentedControl(frame: .zero)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var subView1: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 393.0).isActive = true
        view.backgroundColor = .blue
        return view
    }()
    private var subView2: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 393.0).isActive = true
        view.backgroundColor = .cyan
        return view
    }()
    private var subView3: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 393.0).isActive = true
        view.backgroundColor = .gray
        return view
    }()
    private var subView4: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 393.0).isActive = true
        view.backgroundColor = .yellow
        return view
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
        collectionView.backgroundColor = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let collectionViewWithCriticalTasks: UICollectionView = {
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
    
    private let collectionViewWithHighTasks: UICollectionView = {
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
    
    private let collectionViewWithMediumTasks: UICollectionView = {
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
    
    private let collectionViewWithLowTasks: UICollectionView = {
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
        setConstreints()
        setDelegates()
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
        
        self.tasksCollectionView.reloadData()
    }
    
    // MARK: - Views Settings
    
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.6648817658, green: 0.7693511844, blue: 0.7778732181, alpha: 1)
        
        
        view.addSubview(prioritySegmentedControl)
//        view.addSubview(tasksCollectionView)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        prioritySegmentedControl.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
        
        tasksCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        
        collectionViewWithCriticalTasks.register(TasksCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: "CellForCriticalTask")
        collectionViewWithHighTasks.register(TasksCollectionViewCell.self,
                                             forCellWithReuseIdentifier: "CellForHighTask")
        collectionViewWithMediumTasks.register(TasksCollectionViewCell.self,
                                               forCellWithReuseIdentifier: "CellForMediumTask")
        collectionViewWithLowTasks.register(TasksCollectionViewCell.self,
                                            forCellWithReuseIdentifier: "CellForLowTask")
    }
    
    private func setDelegates() {
        tasksCollectionView.dataSource = self
        tasksCollectionView.delegate = self
        
        self.scrollView.delegate = self
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
//        self.tasksCollectionView.reloadData()
        let xOffset = scrollView.bounds.width * CGFloat(sender.selectedSegmentIndex)
        scrollView.setContentOffset(CGPointMake(xOffset,0), animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch prioritySegmentedControl.selectedSegmentIndex {
//        case 0: return criticalTasksArray.count
//        case 1: return highTasksArray.count
//        case 2: return mediumTasksArray.count
//        default: return lowTasksArray.count
//        }
        
        switch collectionView {
        case collectionViewWithCriticalTasks:
            return criticalTasksArray.count
        case collectionViewWithHighTasks:
            return highTasksArray.count
        case collectionViewWithMediumTasks:
            return mediumTasksArray.count
        case collectionViewWithLowTasks:
            return lowTasksArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TasksCollectionViewCell else { return UICollectionViewCell() }
        var cell = TasksCollectionViewCell()
        
//        var task: Task {
//            switch prioritySegmentedControl.selectedSegmentIndex {
//            case 0: return criticalTasksArray[indexPath.item]
//            case 1: return highTasksArray[indexPath.item]
//            case 2: return mediumTasksArray[indexPath.item]
//            default: return lowTasksArray[indexPath.item]
//            }
//        }
        
//        cell.configure(for: task)
        switch collectionView {
        case collectionViewWithCriticalTasks:
            cell = someName(id: "CellForCriticalTask", indexPath: indexPath, data: criticalTasksArray, collectionView: collectionView)
        case collectionViewWithHighTasks:
            cell = someName(id: "CellForHighTask", indexPath: indexPath, data: highTasksArray, collectionView: collectionView)
        case collectionViewWithMediumTasks:
            cell = someName(id: "CellForMediumTask", indexPath: indexPath, data: mediumTasksArray, collectionView: collectionView)
        case collectionViewWithLowTasks:
            cell = someName(id: "CellForLowTask", indexPath: indexPath, data: lowTasksArray, collectionView: collectionView)
        default:
            print("Unknown collection view")
        }
        
        return cell
    }
    
    func someName(id: String, indexPath: IndexPath, data: [Task], collectionView: UICollectionView) -> TasksCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! TasksCollectionViewCell
        
        let task = data[indexPath.item]
        cell.configure(for: task)
        
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
            self.tasksCollectionView.reloadData()
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
            case 0: self.criticalTasksArray.remove(at: taskIndex)
            case 1: self.highTasksArray.remove(at: taskIndex)
            case 2: self.mediumTasksArray.remove(at: taskIndex)
            default: self.lowTasksArray.remove(at: taskIndex)
            }
            
            self.tasksCollectionView.reloadData()
                        
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        alertController.addAction(deleteButton)
        
        present(alertController, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 20,
               height: collectionView.bounds.width / 2)
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
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            prioritySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            
            
            
//            tasksCollectionView.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor, constant: 10),
//            tasksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
//            tasksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            tasksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        configureContainerView()
    }
    
    private func configureContainerView() {
        scrollStackViewContainer.addArrangedSubview(subView1)
        scrollStackViewContainer.addArrangedSubview(subView2)
        scrollStackViewContainer.addArrangedSubview(subView3)
        scrollStackViewContainer.addArrangedSubview(subView4)
        
        insertCollectionsViewsInContainers()
    }
    
    
    private func insertCollectionsViewsInContainers() {
        NSLayoutConstraint.activate([
            collectionViewWithCriticalTasks.leadingAnchor.constraint(equalTo: subView1.leadingAnchor),
            collectionViewWithCriticalTasks.topAnchor.constraint(equalTo: subView1.topAnchor),
            collectionViewWithCriticalTasks.trailingAnchor.constraint(equalTo: subView1.trailingAnchor),
            collectionViewWithCriticalTasks.bottomAnchor.constraint(equalTo: subView1.bottomAnchor)
        ])
    }
}
