//
//  AddItemTVC.swift
//  ToDoList
//
//  Created by Abdallah on 7/18/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit
import UserNotifications

class AddItemToTodoList: UITableViewController {
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ToDoItem?
    weak var delegate: AddItemDelegate?
    private var dueDate = Date()
    private var datePickerVisable = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        toDoTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            toDoTextField.text = item.text
            doneButton.isEnabled = true
            
            remindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
        toDoTextField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    @IBAction func DatePickerChanged(_ datePicker: UIDatePicker) {
        
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        
        toDoTextField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                
                if let error = error {
                    print("we have premissions")
                } else {
                    print("premissions denied!")
                }
            }
        }
    }
    
    @IBAction func dateChanged(_ datePiker: UIDatePicker) {
        
        dueDate = datePiker.date
        updateDueDateLabel()
    }
    
    private func updateDueDateLabel() {
        
        let formmater = DateFormatter()
        formmater.dateStyle = .medium
        formmater.timeStyle = .short
        dueDateLabel.text = formmater.string(from: dueDate)
        dueDateLabel.textColor = dueDateLabel.tintColor
    }
    
    private func showDatePicker() {
        
        datePickerVisable = true
        let indexPathOfDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathOfDatePicker], with: .fade)
        datePicker.setDate(dueDate, animated: false)
        
    }
    
    private func hideDatePicker() {
        
        if datePickerVisable {
            datePickerVisable = false
            let indexPathOfDatePicker = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexPathOfDatePicker], with: .fade)
            dueDateLabel.textColor = UIColor.black
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisable {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        toDoTextField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 && !datePickerVisable {
            showDatePicker()
        } else {
            hideDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        delegate?.addItemTVCDidCancel(self)
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        
        if let item = itemToEdit {
            
            item.text = toDoTextField.text!
            item.shouldRemind = remindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemTVC(self, didFinishEditing: item)
        } else {
            
            let item = ToDoItem()
            item.text = toDoTextField.text!
            item.shouldRemind = remindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemTVC(self, didFinishAdding: item)
        }
        
    }
    
    
    
}


extension AddItemToTodoList: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        hideDatePicker()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = toDoTextField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    
}
