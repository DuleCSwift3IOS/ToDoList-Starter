//
//  ToDoDetailsViewController.swift
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

class ToDoDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionButton: UIButton!
    
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    var toDoItem: ToDoItem!
    
    var toDoIndex: Int!
    
    let message = "Hello World"
    
    weak var delegate: ToDoListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(message)

        self.taskTitleLabel.text = toDoItem.name
        
        self.taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            
            disableButton()
            
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMM, yyyy hh:mm"
        
        let taskDate = formatter.string(from: toDoItem.completionDate!)
        
        taskCompletionDate.text  = taskDate
        
        
        //self.taskCompletionDate.text = String("\(toDoItem.completionDate)")
        
    }
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        
        taskCompletionButton.isEnabled = true
        
    }
    
    @IBAction func taskDidComplete(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Confirm", message: "Are yiu sure you would like to complete this task?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            
            self.comleteTask(alert: alert)
            
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
       
    }
    

    func comleteTask(alert: UIAlertController) {
        
        toDoItem.isComplete = true
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        delegate?.update()
        
        disableButton()
    }
    
}
