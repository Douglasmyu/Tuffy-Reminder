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
    var update: (() -> Void)?
    
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
        guard var count = UserDefaults.standard.value(forKey: "count") as? Int else {
            return
        }
        
        // Remove the specific task
        UserDefaults.standard.removeObject(forKey: "task_\(currentPosition + 1)")
        
        // Shift tasks after the deleted one
        for i in currentPosition + 1..<count {
            if let nextTask = UserDefaults.standard.value(forKey: "task_\(i + 1)") as? String {
                UserDefaults.standard.setValue(nextTask, forKey: "task_\(i)")
            }
        }
        
        // Decrease the task count
        count -= 1
        UserDefaults.standard.setValue(count, forKey: "count")
        
        // Clear the last unused task
        UserDefaults.standard.removeObject(forKey: "task_\(count + 1)")
        
        // Call the update closure
        update?()
        
        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
    }

}
