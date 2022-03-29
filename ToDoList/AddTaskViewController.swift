//
//  AddTaskViewController.swift
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

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var touchView: UIView = {
       
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.addGestureRecognizer(touchViewTapped)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        return _touchView
    }()

    let toolBarDone = UIToolbar.init()
    
    var activeTextField: UITextField?
    
    var activeTextView: UITextView?
    
    //MARK: - To make a changes on keyboard to show before
    
   // var keyboardNotification: NSNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let navigationItem = UINavigationItem(title: "Add Task")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTouch))
        
        navigationBar.items = [navigationItem]
        
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        taskDetailsTextView.layer.borderWidth = CGFloat(1)
        
        taskDetailsTextView.layer.cornerRadius = CGFloat(3)
        
        
        toolBarDone.sizeToFit()
        
        toolBarDone.barTintColor = UIColor.red
        
        toolBarDone.isTranslucent = false
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
        
        let barBtnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        barBtnDone.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        toolBarDone.items = [flexSpace, barBtnDone, flexSpace]
        
        taskNameTextField.inputAccessoryView = toolBarDone
        
        taskDetailsTextView.inputAccessoryView = toolBarDone
        
        taskNameTextField.delegate = self
        
        taskDetailsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        deregisterForKeyboardNotification()
    }
    
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
            
    }
    
    func deregisterForKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShow(notification: NSNotification) {
        
        view.addSubview(touchView)
        
      //  self.keyboardNotification = notification
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        
        let keyabordSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyabordSize!.height + toolBarDone.frame.size.height + 10.0), right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = UIScreen.main.bounds
        
        aRect.size.height -= keyabordSize!.height
        
        if activeTextField != nil {
            
            if (!aRect.contains(activeTextField!.frame.origin)) {
                
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
                
            }
            
        } else if activeTextView != nil {
            
            
            let textViewPoint: CGPoint = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.size.height + activeTextView!.frame.size.height)
            
            if (!aRect.contains(textViewPoint)) {

                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)

            }
            
        }
        
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        
        touchView.removeFromSuperview()
        //MARK: -  This part is when keyboard going down to set and be on 0 on all points UIEdgeInsets(top:0,left: 0, bottom: 0, right:0)
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
        
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    @objc func doneButtonTapped() {
        
        view.endEditing(true)
        
    }
    @objc func cancelButtonDidTouch() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            
            reportError(title: "Invalid Task Name", message: "Task name is required")
            
            return
            
        }
        
        if taskDetailsTextView.text.isEmpty {
            
            reportError(title: "Invalid Task Details", message: "Task details is requiered")
            
            return
            
        }
        
        let taskDetails: String = taskDetailsTextView.text
        
        let completionDate: Date = taskCompletionDatePicker.date
        
        if completionDate < Date() {
            
            reportError(title: "Invalid Date", message: "Date must be in future")
            
            return
            
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let toDoItem = ToDoItem(context: context)
        
        toDoItem.name = taskName
        
        toDoItem.details = taskDetails
        
        toDoItem.completionDate = completionDate
        
        toDoItem.isComplete = false
        
        toDoItem.startDate = Date()
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        // let toDoItem = ToDoItem(name: taskName, details: taskDetails, completionDate: completionDate)
        
      //  let toDoDict: [String: ToDoItem] = ["Task": toDoItem]
        
       // NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "com.todolistapp.addTask"), object: toDoItem)
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "com.todolistapp.addTask"), object: nil, userInfo: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    func reportError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTextField = nil
        
    }
    
}

extension AddTaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        activeTextView = textView
        
//        guard let notification = self.keyboardNotification else { return }
//
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//
//        let keyabordSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//
//        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyabordSize!.height + toolBarDone.frame.size.height + 10.0), right: 0.0)
//
//        self.scrollView.contentInset = contentInsets
//
//        self.scrollView.scrollIndicatorInsets = contentInsets
//
//        var aRect: CGRect = UIScreen.main.bounds
//
//        aRect.size.height -= keyabordSize!.height
//
//        let textViewPoint: CGPoint = CGPoint(x: textView.frame.origin.x, y: textView.frame.size.height + textView.frame.size.height)
//
//        if (!aRect.contains(textViewPoint)) {
//
//            self.scrollView.scrollRectToVisible(textView.frame, animated: true)
//
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        activeTextView = nil
        
    }
    
}
