//
//  ListDetailsViewController.swift
//  ToDoList
//
//  Created by Abdallah on 8/20/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit

class ListDetailsViewController: UITableViewController {
    
    weak var delegate: AddListDelegate?
    var checkListToEdit: CheckList?
    private var iconName = "default"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        
        if let checkList = checkListToEdit {
            title = "Edit Checklist"
            textField.text = checkList.name
            doneBarButton.isEnabled = true
            iconName = checkList.iconName
        }
        
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    @IBAction func cancel() {
        
        delegate?.ListDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done() {
        
        if let checkList = checkListToEdit {
            checkList.name = textField.text!
            checkList.iconName = iconName
            delegate?.ListDetailViewController(self, didFinishEditing: checkList)
        } else {
            let checkList = CheckList(name: textField.text!, iconName)
            delegate?.ListDetailViewController(self, didFinishAdding: checkList)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath.section == 1 ? indexPath : nil
    }
  
  
}

extension ListDetailsViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
}

extension ListDetailsViewController: UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled =  false
        return true
    }
}

