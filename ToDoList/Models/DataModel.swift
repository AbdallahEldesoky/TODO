//
//  DataModel.swift
//  ToDoList
//
//  Created by Abdallah on 8/23/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [CheckList]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        
        loadChecklist()
        registerDefaults()
        handleFirstTime()
    }
    
    class func nextChecklistItemId() -> Int {
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    func sortChecklists() {
        
        lists.sort(by: { list1, list2 in
            
            list1.sortItems()
            list2.sortItems()
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        })
        
    }

   
    private func documentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklist() {
        
        sortChecklists()
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("error encoding list array \(error.localizedDescription)")
        }
    }
    
    func loadChecklist() {
        
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([CheckList].self, from: data)
                sortChecklists()
            }
            catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    private func registerDefaults() {
        let checklistDict = ["ChecklistIndex": -1, "firstTime": true] as! [String: Any]
        UserDefaults.standard.register(defaults: checklistDict)
    }
    
    private func handleFirstTime() {
        
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "firstTime")
        
        if firstTime {
            
            let list1 = CheckList(name: "Groceries")
            list1.iconName = "Groceries"
            let list2 = CheckList(name: "Movies To Watch")
            list2.iconName = "movie"
            let list3 = CheckList(name: "Travel")
            list3.iconName = "travel"
            let list4 = CheckList(name: "Private")
            list4.iconName = "private"
            let list5 = CheckList(name: "Family")
            list5.iconName = "family"
            lists = [list1,list2,list3,list4,list5]
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "firstTime")
            userDefaults.synchronize()
        }
    }
}
