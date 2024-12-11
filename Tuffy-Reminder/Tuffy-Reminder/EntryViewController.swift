//
//  EntryViewController.swift
//  Tuffy-Reminder
//
//  Created by Douglas Yu on 12/6/24.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        field.delegate = self
        
        // Configure the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        // Save task text
        UserDefaults().setValue(newCount, forKey: "count")
        UserDefaults().setValue(text, forKey: "task_\(newCount)")
        
        // Save task completion status
        UserDefaults().setValue(false, forKey: "task_\(newCount)_done")
        
        // Save task date
        let selectedDate = datePicker.date
        UserDefaults().setValue(selectedDate, forKey: "task_\(newCount)_date")
        
        update?()
        navigationController?.popViewController(animated: true)
    }
}

