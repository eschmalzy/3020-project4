//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Ethan Schmalz on 9/15/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController, UIGestureRecognizerDelegate {

    var itemStore: ItemStore!
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "addItem", sender: sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if itemStore.allItems.count > 0{
            let item = itemStore.allItems[itemStore.allItems.count - 1]
            if (item.name == "" && item.details == ""){
                itemStore.removeItem(item)
            }
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 65
        tableView.estimatedRowHeight = 65
        navigationController?.navigationBar.barTintColor = UIColor(red: 1.00, green: 0.23, blue: 0.19, alpha: 1.00)
        navigationController?.navigationBar.tintColor = UIColor.white
        let titleText = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = titleText
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: Selector(("handleLongPress")))
//        longPress.minimumPressDuration = 0.5
//        longPress.delaysTouchesBegan = true
//        longPress.delegate = self
//        self.tableView.addGestureRecognizer(longPress)
        
    }
    
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        print("longpress")
//        let touchPoint = gestureRecognizer.location(in: self.tableView)
//        if let indexPath = tableView.indexPathForRow(at: touchPoint){
//            let row = indexPath.row
//            let menu = UIMenuController.shared
//            let sendItem = UIMenuItem(title: "Send", action: Selector(("sendItem")))
//            menu.menuItems = [sendItem]
//            menu.isMenuVisible = true
//            menu.setTargetRect(CGRect.zero, in: self.tableView)
//        }
    }
    
    @IBAction func cancelNoteViewController(_ segue: UIStoryboardSegue){
        
    }
    
    @IBAction func cancelAddViewController(_ segue: UIStoryboardSegue){
        let item = itemStore.allItems[itemStore.allItems.count - 1]
        itemStore.removeItem(item)
    }
    
    @IBAction func saveNote(_ segue: UIStoryboardSegue){
        guard let itemDetailsViewController = segue.source as? DetailViewController,
            let item = itemDetailsViewController.item else {
                return
        }
        let row = itemDetailsViewController.row
        print("row ", row ,item.name, item.details)
        itemStore.allItems[row].name = item.name
        itemStore.allItems[row].details = item.details
        
    }
    
    @IBAction func saveChanges (_ segue: UIStoryboardSegue){
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemStore == nil {
            return 0
        } else{
            return itemStore.allItems.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell

        
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor =  UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 0.20)
            cell.detailLabel.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 0.01)
            cell.nameLabel.backgroundColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 0.01)

        } else {
            cell.backgroundColor = UIColor.white
        }
        // Configure the cell...
        let item = itemStore.allItems[indexPath.row]

        cell.nameLabel.text = item.name
        cell.detailLabel.text = item.details
        if let data = UserDefaults.standard.data(forKey: item.uuid),let image = UIImage(data: data){
            print("image ", image)
            cell.drawnImage?.image = image
        } else{
            print("no image")
            cell.drawnImage?.isHidden = true
        }
        return cell
    }
 

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title:title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.itemStore.removeItem(item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)

            present(ac,animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showItem"?:
            if let row = tableView.indexPathForSelectedRow?.row{
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.row = row
            }
        case "addItem"?:
            let item = itemStore.createItem()
            let addViewController = segue.destination as! AddViewController
            addViewController.item = item
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

    
}
