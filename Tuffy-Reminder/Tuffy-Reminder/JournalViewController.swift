//
//  JournalViewController.swift
//  Tuffy-Reminder
//
//  Created by Christopher Mireles on 12/8/24.
//

import UIKit

class JournalViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        self.title = "Journals"
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey:"count")
        }
        }

    
    func updateEntrys() {
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        
        for x in 0..<count {
            if let taskEntry = UserDefaults().value(forKey: "task_\(x + 1)") as? [String: String],
               let task = taskEntry["task"],
               let date = taskEntry["date"] {
                tasks.append("\(task) (\(date))")
            }
        }
        
        tableView.reloadData()
    }

        // Do any additional setup after loading the view.
    
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "Journal Entry"
        vc.update = {
            DispatchQueue.main.async {
                self.updateEntrys()
            }
            
            
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JournalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: <#T##IndexPath#>, animated: true)
    }
        
    }


extension JournalViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }

    
}
