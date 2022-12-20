//
//  ViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 20.03.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
//    let appDelegate = AppDelegate()
    
    private let prioritySegmentedControl = PrioritySegmentedControl(frame: .zero)
    
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
    
    var tasksArray: [Task] = []
    
    // MARK: - Live Circle
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
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
        
        let sortByDate = NSSortDescriptor(key: "dateOfCreation", ascending: false)
        let sortByCompletion = NSSortDescriptor(key: "isCompleted", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByCompletion, sortByDate]
        
        do {
            tasksArray = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.tasksCollectionView.reloadData()
    }
    
    // MARK: setupViews
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.6648817658, green: 0.7693511844, blue: 0.7778732181, alpha: 1)
        
        view.addSubview(prioritySegmentedControl)
        view.addSubview(tasksCollectionView)
        
        prioritySegmentedControl.addTarget(self, action: #selector(priorityChanged(_:)), for: .valueChanged)
        
        tasksCollectionView.register(TasksCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
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
    
    @objc private func priorityChanged(_ sender: UISegmentedControl) {
        self.tasksCollectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var criticalTasksCount = 0
        var highTasksCount = 0
        var mediumTasksCount = 0
        var lowTasksCount = 0
        
        for task in tasksArray {
            switch task.priority {
            case 0: criticalTasksCount += 1
            case 1: highTasksCount += 1
            case 2: mediumTasksCount += 1
            default: lowTasksCount += 1
            }
        }
        
        var resultCount = 0
        
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0: resultCount = criticalTasksCount
        case 1: resultCount = highTasksCount
        case 2: resultCount = mediumTasksCount
        default: resultCount = lowTasksCount
        }
        
        return resultCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TasksCollectionViewCell else { return UICollectionViewCell() }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        let task = tasksArray[indexPath.item]
                
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.descriptionText
        cell.timeIntervalLabel.text = formatter.string(from: task.deadlineDate ?? .now)
        
//        let attributedForCompleted = NSAttributedString(string: task.title!, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
//        let attributedForNotCompleted = NSAttributedString(string: task.title!, attributes: [.strikethroughStyle: NSUnderlineStyle.patternDot.rawValue])
//
//        cell.titleLabel.attributedText = task.isCompleted ? attributedForCompleted : attributedForNotCompleted
   
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
        setupEditButton(indexPath.item)
    }
    
    // MARK: UIContextMenu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {

        let taskIndex = indexPaths.first?[1]

        guard let taskIndex else {
            return UIContextMenuConfiguration()
        }

//        let taskIsCompleted = tasksDictionary[sectionIndex!]?[taskIndex!].isCompleted
//        let completedButtonTitle = taskIsCompleted! ? "Not Completed" : "Completed"

        return UIContextMenuConfiguration(actionProvider:  { [weak self] suggestedActions in
            return UIMenu(children: [
                UIAction(title: "completedButtonTitle", image: UIImage(systemName: "app.badge.checkmark")) { [weak self] _ in
                    self?.setupCompletedButton(taskIndex)
                },
                UIAction(title: "Edit", image: UIImage(systemName: "highlighter")) { [weak self] _ in
                    self?.setupEditButton(taskIndex)
                },
                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.setupDeleteButton(taskIndex)
                }
            ])
        })
    }

    func setupCompletedButton(_ taskIndex: Int) {
        tasksArray[taskIndex].isCompleted.toggle()
        
        let context = getContext()
        
        do {
            try context.save()
            self.tasksCollectionView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func setupEditButton(_ taskIndex: Int) {
        let task = tasksArray[taskIndex]
        let createTaskVC = CreateTaskViewController()

        createTaskVC.taskTitleTextField.text = task.title
        createTaskVC.deadlineDatePicker.date = task.deadlineDate!
        createTaskVC.prioritySegmentedControl.selectedSegmentIndex = Int(task.priority)
        createTaskVC.descriptionTextView.text = task.descriptionText
        createTaskVC.isCompleted = task.isCompleted
        createTaskVC.priorityKeyForEditing = Int(task.priority)
        createTaskVC.indexPathForEditing = taskIndex
        createTaskVC.createTaskButton.tag = 2

        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }

    func setupDeleteButton(_ taskIndex: Int) {
        let alertController = UIAlertController(title: "Confirm the deletion",
                                                message: "If you press the \"Delete\" button, this action cannot be undone.",
                                                preferredStyle: .alert)

        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            let context = self?.getContext()
            let fetchRequest = Task.fetchRequest()
            
            let sortByDate = NSSortDescriptor(key: "dateOfCreation", ascending: false)
            let sortByCompletion = NSSortDescriptor(key: "isCompleted", ascending: true)
            
            fetchRequest.sortDescriptors = [sortByCompletion, sortByDate]
            
            guard let array = try? context?.fetch(fetchRequest) else { return }
            
            context?.delete(array[taskIndex])
            
            do {
                try context?.save()
                
                self?.tasksArray.remove(at: taskIndex)
                self?.tasksCollectionView.reloadData()
            } catch let error {
                print(error.localizedDescription)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 20,
               height: collectionView.bounds.width / 2)
    }
}


// MARK: - Constraints

extension MainViewController {
    private func setConstreints() {
        NSLayoutConstraint.activate([
            prioritySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tasksCollectionView.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor, constant: 10),
            tasksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tasksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tasksCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

