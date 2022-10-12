//
//  CreateTaskViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextViewDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Title"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let deadlineDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Deadline"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "Priority"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle("Create Task", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.08235294118, blue: 0.0862745098, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.8666666667, green: 0.968627451, blue: 0.9725490196, alpha: 1)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let taskTitleTextField = TaskTitleTextField()
    let descriptionTextView = DescriptionTextView()
    let deadlineDatePicker = CustomDatePicker()
    let prioritySegmentedControl = PrioritySegmentedControl(frame: .zero)
    
    var priorityKeyForEditing: Int? = nil
    var indexPathForEditing: Int? = nil
    var isCompleted: Bool = false
    
    
    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        setConstreints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        if self.createTaskButton.tag != 1 {
            self.createTaskButton.setTitle("Save Task", for: .normal)
        }
    }
    
    
    // MARK: - Setup Views
    
    private func setupViews() {
        self.view.backgroundColor = #colorLiteral(red: 0.6648817658, green: 0.7693511844, blue: 0.7778732181, alpha: 1)
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Create Task"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.01568627451, green: 0.3215686275, blue: 0.337254902, alpha: 1)
                
        descriptionTextView.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(taskTitleTextField)
        view.addSubview(deadlineDateLabel)
        view.addSubview(deadlineDatePicker)
        view.addSubview(priorityLabel)
        view.addSubview(prioritySegmentedControl)
        view.addSubview(descriptionLabel)
        view.addSubview(createTaskButton)
        view.addSubview(descriptionTextView)
        
        self.createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - createTaskButton Action

    @objc func createTaskButtonTapped() {
        self.view.endEditing(true)
        
        guard let mainVC = navigationController?.viewControllers.first as? MainViewController else {
            return }
        
        guard let titleText = taskTitleTextField.text?.trimmingCharacters(in: .whitespaces), !titleText.isEmpty else {
            showAlert()
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        let deadlineDateString = formatter.string(from: deadlineDatePicker.date)
        let prioritiKey = prioritySegmentedControl.selectedSegmentIndex
        let descriptionText = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        
        let newTask = Task(isCompleted: isCompleted,
                           title: titleText,
                           deadLineDate: deadlineDateString,
                           priority: prioritiKey,
                           description: descriptionText)
        
        if createTaskButton.tag == 1 {
            mainVC.tasksDictionary[prioritiKey]?.insert(newTask, at: 0)
        } else {
            mainVC.tasksDictionary[priorityKeyForEditing!]?.remove(at: indexPathForEditing!)
            mainVC.tasksDictionary[prioritiKey]?.insert(newTask, at: 0)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Alert Setup
    
    private func showAlert() {
        let alertController = UIAlertController(title: "The title field is empty", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { action in
            let titleText = alertController.textFields![0].text
            self.taskTitleTextField.text = titleText
        }
        
        alertController.addTextField { uiTextField in
            uiTextField.returnKeyType = .done
            uiTextField.clearButtonMode = .whileEditing
            uiTextField.placeholder = "Enter a short title"
        }
        
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


// MARK: - Actions with the keyboard

extension CreateTaskViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}


// MARK: - Constreints Setup

extension CreateTaskViewController {
    
    private func setConstreints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            taskTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.5),
            
            deadlineDateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 25),
            deadlineDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            deadlineDatePicker.centerYAnchor.constraint(equalTo: deadlineDateLabel.centerYAnchor),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priorityLabel.topAnchor.constraint(equalTo: deadlineDateLabel.bottomAnchor, constant: 40),
            priorityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            prioritySegmentedControl.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 20),
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            prioritySegmentedControl.heightAnchor.constraint(equalToConstant: 35),
            
            createTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createTaskButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
