//
//  ViewController.swift
//  ToDoList
//
//  Created by Abdallah on 7/17/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    private let cellIdentifier = "ToDoListCell"
    
     var checklist: CheckList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckMarks(for: cell, with: item)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckMarks(for: cell, with: item)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddItemToTodoList") as! AddItemToTodoList
        controller.delegate = self
        
        let itemToEdit = checklist.items[indexPath.row]
        controller.itemToEdit = itemToEdit
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    private func configureText(for cell: UITableViewCell, with item: ToDoItem) {
        
        let todoLabel = cell.viewWithTag(1000) as! UILabel
        let todoDateLabel = cell.viewWithTag(1001) as! UILabel
        todoDateLabel.textColor = UIColor.cyan
        todoLabel.text = item.text
        //todoLabel.sizeToFit()
        todoLabel.numberOfLines = 0
        
        if item.shouldRemind && item.dueDate > Date() {
            
            let formmater = DateFormatter()
            formmater.dateStyle = .medium
            formmater.timeStyle = .short
            todoDateLabel.text = formmater.string(from: item.dueDate)
            //todoDateLabel.sizeToFit()
        }
        else {
            todoDateLabel.text = "Not scheduled!"
        }
    }
    
    private func configureCheckMarks(for cell: UITableViewCell, with item: ToDoItem) {
        
        let checkLabel = cell.viewWithTag(1002) as! UILabel
        if item.checked {
            checkLabel.isHidden = false
        } else {
            checkLabel.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addItem" {
            let controller = segue.destination as! AddItemToTodoList
            controller.delegate = self
            
        }
        
    }
  
}

extension ToDoListTableViewController: AddItemDelegate {
    
    
    func addItemTVCDidCancel(_ controller: AddItemToTodoList) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemTVC(_ controller: AddItemToTodoList, didFinishAdding item: ToDoItem) {
        
        checklist.items.append(item)
        checklist.sortItems()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func addItemTVC(_ controller: AddItemToTodoList, didFinishEditing item: ToDoItem) {
        
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        checklist.sortItems()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
}

