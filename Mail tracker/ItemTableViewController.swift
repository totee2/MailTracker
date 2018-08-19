//
//  ItemTableViewController.swift
//  Mail tracker
//
//  Created by Antonia Schmidt-Lademann on 16/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var items = [Item]()
    var sent:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = editButtonItem
        //Load any saved items, otherwise load sample data
        if let savedItems = loadItems(){
            items += savedItems
        } else {
            //Load the sample data
            loadSampleItems()
        }
    }
    
    func loadSampleItems(){
        let photo1 = UIImage(named: "Image1")!
        let item1 = Item(name: "Marito", photo: photo1, sent: 0, sentDate: NSDate(timeIntervalSinceNow: 0))!
        
        
        let photo2 = UIImage(named: "Image2")!
        let item2 = Item(name: "Doguito", photo: photo2, sent: 1, sentDate: NSDate(timeIntervalSinceNow: 0))!
        
        let photo3 = UIImage(named: "Image3")!
        let item3 = Item(name: "Gatito", photo: photo3, sent: 0, sentDate: NSDate(timeIntervalSinceNow: 0))!
        
        items += [item1, item2, item3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if(section == 1){
            return "Sent (\(getSectionItems(section: 1).count))"
        }
        else {
            return "Received (\(getSectionItems(section: 0).count))"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionItems(section: section).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "ItemTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItemTableViewCell

        //Fetches the appropriate item for the data source layout
        let item = getSectionItems(section: section)[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        cell.sentControl.messageStatus = item.sent
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        cell.date.text = df.string(from: item.date as Date)

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    private func getSectionItems(section :Int) -> [Item] {
        var sectionItems = [Item]()
        for item in items {
            if (item.sent != section) {
                sectionItems.append(item)
            }
        }
        return sectionItems
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
            case "AddItem":
                if #available(iOS 10.0, *) {
                    os_log("Adding a new meal.", log: OSLog.default, type: .debug)
                } else {
                    // Fallback on earlier versions
            }
            
            case "ShowDetail":
                guard let itemDetailViewController = segue.destination as? ItemViewController else {
                    fatalError("Unexpected destination : \(segue.destination)")
            }
            
                guard let selectedItemCell = sender as? ItemTableViewCell else {
                    fatalError("Unexpected Sender : \(String(describing: sender))")
            }
            
                
            let selectedItem = items.first{$0.name == selectedItemCell.nameLabel.text}!
                
                
            print("item \(selectedItem)")
            sent = selectedItem.sent
            itemDetailViewController.item = selectedItem
            
        default: fatalError("Unexpected Segue Identifier ; \(String(describing: segue.identifier))")
        }
        
        /*if segue.identifier == "ShowDetail"{
            let itemDetailViewController = segue.destination as! ItemViewController
            //get the cell that generated this segue
            if let selectedItemCell = sender as? ItemTableViewCell{
                let indexPath = tableView.indexPath(for: selectedItemCell)!
                let selectedItem = items[indexPath.row]
                itemDetailViewController.item = selectedItem
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new item")
        }*/
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? ItemViewController, let item = sourceViewController.item {
            
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                for i in 0..<items.count {
                    if (items[i].name == item.name) {
                        items[i] = item;
                    }
                }
                
                // update an existing item
                if(item.sent == sent) {
                    print(selectedIndexPath.row)
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    print(selectedIndexPath.row)
                    print(selectedIndexPath.section)
                    //tableView.deleteRows(at: [selectedIndexPath], with: .fade)
                    print("dkjhs")
                    /*var newIndexPath = IndexPath();
                    if(item.sent == 0) {
                        newIndexPath = IndexPath(row: getSectionItems(section: 1).count, section: 1)
                    } else if(item.sent == 1) {
                        newIndexPath = IndexPath(row: getSectionItems(section: 0).count, section: 0)
                    }
                    */
                    //tableView.insertRows(at: [newIndexPath], with: .bottom)
                    self.tableView.reloadData()
                    print("dkjhs")
                }
            }
            else {
                //add a new item
                var newIndexPath = IndexPath();
                if(item.sent == 0) {
                    newIndexPath = IndexPath(row: getSectionItems(section: 1).count, section: 1)
                } else if(item.sent == 1) {
                    newIndexPath = IndexPath(row: getSectionItems(section: 0).count, section: 0)
                }
                
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            //Save the items
            saveItems()
        }
        self.tableView.reloadData()
    }
    //MARK: NSCoding
    func saveItems(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        
        if !isSuccessfulSave{
            print("failed to save items")
        }
    }
    
    func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
}
