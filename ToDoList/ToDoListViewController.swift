//
//  ToDoListViewController.swift
//  ToDoList
//
/*
 MIT License
 
 Copyright (c) 2018 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

protocol ToDoListDelegate: class {
    
    func update()
}

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var toDoItems: [ToDoItem] {
        
        do {
            
            return try! context.fetch(ToDoItem.fetchRequest())
            
        } catch  {
            
            print("Couldn't fetch data")
        }
        
        return [ToDoItem]()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
//        let testItem = ToDoItem(name: "Test Item", details: "Test Details", completionDate: Date())
//        
//        let testItem2 = ToDoItem(name: "Test Item 2", details: "Test Details 2", completionDate: Date())
//     
//        self.toDoItems.append(testItem)
//        
//        self.toDoItems.append(testItem2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init(rawValue: "com.todolistapp.addTask"), object: nil)
        
        
    }
    
    @objc func addNewTask(_ notification: NSNotification) {
       /*
        var toDoItem: ToDoItem!
        
        if let task = notification.object as? ToDoItem {
            
            toDoItem = task
            
        }
        else if let taskDict = notification.userInfo as NSDictionary? {
            guard let task = taskDict["Task"] as? ToDoItem else { return }
            
            toDoItem = task
        }
        else {
            
            return
            
        }
        toDoItems.append(toDoItem)
        
        //Sort hronologicly
        
        toDoItems.sort(by: { $0.completionDate < $1.completionDate })
        */
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: false)
        
    }
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
        
    }
    
    @objc func editTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            
        } else {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
           // self.toDoItems.remove(at: indexPath.row)
            
            let toDoItem = self.toDoItems[indexPath.row]
            
            self.context.delete(toDoItem)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
        return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems[indexPath.row]
        
        let toDoTuple = (indexPath.row, selectedItem)
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        let toDoItem = toDoItems[indexPath.row]
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text =  toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            
            guard let destionatioVC = segue.destination as? ToDoDetailsViewController else { return }
            
            guard let toDoTuple = sender as? (Int,ToDoItem) else { return }
            
            destionatioVC.toDoIndex = toDoTuple.0
            
            destionatioVC.toDoItem = toDoTuple.1
            
            destionatioVC.delegate = self
            
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "com.todolistapp.addTask"), object: nil)
        
    }
    
    

}

extension ToDoListViewController: ToDoListDelegate {
    
    func update() {
        
        
        //toDoItems[index] = task
        
        tableView.reloadData()
        
    }
    
}
