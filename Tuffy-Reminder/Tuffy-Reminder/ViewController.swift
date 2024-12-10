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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let location = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else { return }

        let taskIndex = indexPath.row
        let alert = UIAlertController(title: "Edit Task", message: "Update your task name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.tasks[taskIndex]
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            UserDefaults.standard.setValue(text, forKey: "task_\(taskIndex + 1)")
            
            self?.updateTask()
        }))
        present(alert, animated: true)
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
        vc.task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        vc.currentPosition = isSearching ? tasks.firstIndex(of: filteredTasks[indexPath.row]) ?? indexPath.row : indexPath.row
        vc.update = { [weak self] in
            self?.updateTask()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredTasks.count : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.textLabel?.text = task
        
        var toggleButton: UIButton
        if let existingButton = cell.viewWithTag(1001) as? UIButton {
            toggleButton = existingButton
        } else {
            let buttonSize: CGFloat = 20
            toggleButton = UIButton(frame: CGRect(x: cell.frame.width - 70, y: (cell.frame.height - buttonSize) / 2, width: buttonSize, height: buttonSize))
            toggleButton.tag = 1001
            toggleButton.addTarget(self, action: #selector(toggleTaskStatus(_:)), for: .touchUpInside)
            toggleButton.layer.cornerRadius = buttonSize / 2
            toggleButton.clipsToBounds = true
            cell.addSubview(toggleButton)
        }
        
        let taskIndex = isSearching ? tasks.firstIndex(of: filteredTasks[indexPath.row]) ?? indexPath.row : indexPath.row
        let isDone = UserDefaults.standard.bool(forKey: "task_\(indexPath.row + 1)_done")
        toggleButton.backgroundColor = isDone ? .green : .red
        
        cell.accessoryType = isDone ? .checkmark : .none

        return cell
    }


    @objc func toggleTaskStatus(_ sender: UIButton) {
        //figure out what cell is tapped
        guard let indexPath = tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: tableView)) else { return }
        
        let taskIndex = isSearching ? tasks.firstIndex(of: filteredTasks[indexPath.row]) ?? indexPath.row : indexPath.row
        let isDone = UserDefaults.standard.bool(forKey: "task_\(indexPath.row + 1)_done")
        
        //Toggling status and making sure its the right one
        UserDefaults.standard.setValue(!isDone, forKey: "task_\(indexPath.row + 1)_done")
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
