
// Tuffy-Reminder

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    public var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        datePicker.datePickerMode = .dateAndTime
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }

    @objc func didTapSave() {
        guard let text = textField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a task name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        let date = datePicker.date

        // Save task with date
        guard var count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }

        UserDefaults().setValue(text, forKey: "task_\(count + 1)")
        UserDefaults().setValue(date, forKey: "task_\(count + 1)_date")
        UserDefaults().setValue(false, forKey: "task_\(count + 1)_done")

        count += 1
        UserDefaults().setValue(count, forKey: "count")

        update?()

        navigationController?.popViewController(animated: true)
    }
}


