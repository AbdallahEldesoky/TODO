//
//  AddToDoItemViewControllerDelegate.swift
//  ToDoList
//
//  Created by Abdallah on 7/18/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import Foundation

protocol AddItemDelegate: class {
    
    func addItemTVCDidCancel(_ controller: AddItemToTodoList)
    
    func addItemTVC(_ controller: AddItemToTodoList, didFinishAdding item: ToDoItem)
    
    func addItemTVC(_ controller: AddItemToTodoList, didFinishEditing item: ToDoItem)
}
