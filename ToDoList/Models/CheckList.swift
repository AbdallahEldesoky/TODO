//
//  CheckList.swift
//  ToDoList
//
//  Created by Abdallah on 8/20/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit

class CheckList: NSObject, Codable {
    
    var name: String
    var iconName = "default"
    var items = [ToDoItem]()
    
    init(name: String, _ iconName: String = "default") {
        self.name =  name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        
        return items.reduce(0) { count, item in
            count + (item.checked ? 0 : 1)
        }
    }

    func sortItems() {
        
        items.sort { (item1, item2) -> Bool in
            
            return item1.dueDate < item2.dueDate
        }
    }
}
