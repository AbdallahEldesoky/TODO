//
//  IconPickerViewController.swift
//  ToDoList
//
//  Created by Abdallah on 8/24/19.
//  Copyright © 2019 Abdallah Eldesoky. All rights reserved.
//

import UIKit

class IconPickerViewController: UITableViewController {

    weak var delegate: IconPickerViewControllerDelegate?
    private let iconIdentifier = "iconCell"
    private let icons = ["default", "Appointment", "birthday", "chores", "drinks", "family", "folder", "Groceries", "inbox", "movie", "music",  "photos","private", "travel", "trips"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose Icon"
        navigationItem.largeTitleDisplayMode = .never
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: iconIdentifier, for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)

        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }

}
