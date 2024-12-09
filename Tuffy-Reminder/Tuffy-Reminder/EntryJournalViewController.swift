//
//  EntryJournalViewController.swift
//  Tuffy-Reminder
//
//  Created by Christopher Mireles on 12/8/24.
//

import UIKit

class EntryJournalViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var field: UITextField!
    
    
    var update: (() -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",style: .done, target: self, action: #selector(saveJournal))

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveJournal()
        
        return true
    }

    @objc func saveJournal() {
        guard let text = field.text, !text.isEmpty else { return }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let currentDateTime = dateFormatter.string(from: Date())
        
        let taskEntry: [String: String] = ["task": text, "date": currentDateTime]
        UserDefaults().set(taskEntry, forKey: "task_\(newCount)")
        UserDefaults().set(newCount, forKey: "count")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }

    
    
}
