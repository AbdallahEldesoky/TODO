//
//  ListDetailsViewControllerDelegate.swift
//  ToDoList
//
//  Created by Abdallah on 8/20/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import Foundation


protocol AddListDelegate: class {
    
    func ListDetailViewControllerDidCancel(_ controller: ListDetailsViewController)
    func ListDetailViewController(_ controller: ListDetailsViewController, didFinishAdding checklist: CheckList)
    func ListDetailViewController(_ controller: ListDetailsViewController, didFinishEditing checklist: CheckList)
    
}
