//
//  TaskViewController.swift
//  Tuffy-Reminder
//
//  Created by Douglas Yu on 12/7/24.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    var task: String?
    var currentPosition: Int = 0 // Index of the task to delete
    
    // Computed property to manage task count in UserDefaults
    var count: Int {
        get {
            return UserDefaults.standard.integer(forKey: "count")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "count")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
        // Decrease the task count
        let newCount = count - 1
        count = newCount // Save the updated count to UserDefaults
        
        // Remove the specific task
        UserDefaults.standard.setValue(nil, forKey: "task_\(currentPosition)")
        
        // Shift tasks after the deleted one
        for i in currentPosition..<newCount {
            if let nextTask = UserDefaults.standard.value(forKey: "task_\(i + 1)") as? String {
                UserDefaults.standard.setValue(nextTask, forKey: "task_\(i)")
            }
        }
        
        // Clear the last unused task
        UserDefaults.standard.setValue(nil, forKey: "task_\(newCount + 1)")
        
        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
    }
}
