//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Abdallah on 7/17/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import Foundation
import UserNotifications

class ToDoItem: NSObject, Codable{
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemId()
    }
    
    deinit {
        removeNotification()
    }

    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
       
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
           
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calender = Calendar(identifier: .gregorian)
            let component = calender.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
