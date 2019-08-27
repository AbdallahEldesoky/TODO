//
//  IconPickerViewControllerDelegate.swift
//  ToDoList
//
//  Created by Abdallah on 8/24/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import Foundation

protocol IconPickerViewControllerDelegate: class {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
    
}
