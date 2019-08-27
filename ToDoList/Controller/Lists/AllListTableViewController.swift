//
//  AllListTableViewController.swift
//  ToDoList
//
//  Created by Abdallah on 8/20/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit

class AllListTableViewController: UITableViewController {
    
    var dataModel: DataModel!
    private let cellIdentifier = "AllListIdentfier"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "showTodoList", sender: checklist)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTodoList" {
            let controller = segue.destination as! ToDoListTableViewController
            controller.checklist = sender as? CheckList
        } else if segue.identifier == "EditChecklist" {
            let controller = segue.destination as! ListDetailsViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataModel.lists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if let defaultCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = defaultCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        let remainingChecklist = checklist.countUncheckedItems()
        cell.textLabel?.text = checklist.name
        cell.imageView?.image =  UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton
        
        if checklist.items.count == 0 {
            cell.detailTextLabel?.text = "No Items"
        } else {
            cell.detailTextLabel?.text = remainingChecklist == 0 ? "All Done" : "\(remainingChecklist) Remaining"
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "showTodoList", sender: checklist)
    }
    
    @IBAction func AddChecklist(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailsViewController
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
        //performSegue(withIdentifier: "AddCheckList", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailsViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checkListToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension AllListTableViewController: AddListDelegate {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailsViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailsViewController, didFinishAdding checklist: CheckList) {
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func ListDetailViewController(_ controller: ListDetailsViewController, didFinishEditing checklist: CheckList) {
        
        dataModel.sortChecklists()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension AllListTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
