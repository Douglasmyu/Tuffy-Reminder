//
//  ViewController.swift
//  Tuffy-Reminder
//
//  Created by Douglas Yu on 11/24/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tasks = [String]()
    var filteredTasks = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Setup
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        // Get all current saved task
        updateTask()
    }
    
    func updateTask() {
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        for x in 0..<count {
            if let task = UserDefaults.standard.value(forKey: "task_\(x+1)") as? String {
                tasks.append(task) // Append the task (String) to the tasks array
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        //show another view controller
        
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTask()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        vc.currentPosition = indexPath.row
        vc.update = { [weak self] in
            self?.updateTask()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there is user input in search bar
        if (isSearching) {
            return filteredTasks.count
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var task = tasks[indexPath.row]
        if (isSearching) {
            task = filteredTasks[indexPath.row]
        }
        
        cell.accessoryType = .checkmark
        cell.textLabel?.text = task
        
        // cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredTasks.removeAll()
        } else {
            isSearching = true
            filteredTasks = tasks.filter({ $0.lowercased().contains(searchText.lowercased())})
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredTasks.removeAll()
        tableView.reloadData()
    }
}
