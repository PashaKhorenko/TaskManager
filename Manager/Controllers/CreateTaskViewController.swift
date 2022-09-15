//
//  CreateTaskViewController.swift
//  Manager
//
//  Created by Pasha Khorenko on 07.05.2022.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextViewDelegate {
    
    private let titleLabel = TitleLabel()
    let taskTitleTextField = TaskTitleTextField()
    private let statrDateLabel = StartDateLabel()
    let startDatePicker = StartDatePicker()
    private let deadlineDateLabel = DeadlineDaneLabel()
    let deadlineDatePicker = DeadlineDatePicker()
    private let priorityLabel = PriorityLabel()
    let prioritySegmentedControl = PrioritySegmentedControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let descriptionLabel = DescriptionLabel()
    let createTaskButton = CreateTaskButton()
    let descriptionTextView = DescriptionTextView()
    
    var priorityKeyForEditing: Int? = nil
    var indexPathForEditing: Int? = nil
    var isCompleted: Bool = false
    
    
    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        setConstreints()
        setDelegates()
        
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        if self.createTaskButton.tag != 1 {
            self.createTaskButton.setTitle("Save Task", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    
    // MARK: - Setup Views
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(taskTitleTextField)
        view.addSubview(statrDateLabel)
        view.addSubview(startDatePicker)
        view.addSubview(deadlineDateLabel)
        view.addSubview(deadlineDatePicker)
        view.addSubview(priorityLabel)
        view.addSubview(prioritySegmentedControl)
        view.addSubview(descriptionLabel)
        view.addSubview(createTaskButton)
        view.addSubview(descriptionTextView)
        
        self.createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Create Task"
    }
    
    private func setDelegates() {
        descriptionTextView.delegate = self
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
        let startDateString = formatter.string(from: startDatePicker.date)
        let deadlineDateString = formatter.string(from: deadlineDatePicker.date)
        
        let prioritiKey = prioritySegmentedControl.selectedSegmentIndex
        
        let descriptionText = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        
        let newTask = Task(isCompleted: isCompleted,
                           title: titleText,
                           startDate: startDateString,
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
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


// MARK: - Constreints Setup

extension CreateTaskViewController {
    
    private func setConstreints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            taskTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            statrDateLabel.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 40),
            statrDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            startDatePicker.centerYAnchor.constraint(equalTo: statrDateLabel.centerYAnchor),
            startDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            deadlineDateLabel.topAnchor.constraint(equalTo: statrDateLabel.bottomAnchor, constant: 25),
            deadlineDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            deadlineDatePicker.centerYAnchor.constraint(equalTo: deadlineDateLabel.centerYAnchor),
            deadlineDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            priorityLabel.topAnchor.constraint(equalTo: deadlineDateLabel.bottomAnchor, constant: 40),
            priorityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            prioritySegmentedControl.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 20),
            prioritySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prioritySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            prioritySegmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: prioritySegmentedControl.bottomAnchor, constant: 35),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            createTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            createTaskButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            descriptionTextView.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor, constant: -35)
        ])
    }
}
