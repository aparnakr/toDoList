//
//  ViewController.swift
//  ToDoList
//
//  Created by Aparna Krishnan on 12/31/15.
//  Copyright © 2015 Aparna. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var tField: UITextField!
    var items: [Item] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Item")
        let results: [AnyObject]?
        do{
            try results = context.executeFetchRequest(request)
        }
        catch _{
            results = nil
        }
        if results != nil{
            self.items = results as! [Item]
        }
        self.tableView.reloadData()
    

    }
    
    func configTfield(textField:UITextField){
        textField.placeholder = "add new item"
        self.tField = textField
        
    }
    func alertpopup() {
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }
        let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.saveaction()
        }
        alert.addTextFieldWithConfigurationHandler(configTfield)
        alert.addAction(cancel)
        alert.addAction(save)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func saveaction(){
        print("SAVED")
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
        item.title = tField.text
        
        do {
            try context.save()
        }
        catch _{
            
        }
        let request = NSFetchRequest(entityName: "Item")
        let results: [AnyObject]?
        do{
            try results = context.executeFetchRequest(request)
        }
        catch _{
            results = nil
        }
        if results != nil{
            self.items = results as! [Item]
        }
        self.tableView.reloadData()
        
        
    }
    @IBAction func addButtonPressed(sender: AnyObject) {
        alertpopup()
            }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.items[indexPath.row].title
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //items[indexPath.row].title
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        print(self.items[indexPath.row])
        context.deleteObject(self.items[indexPath.row])
        do{
            try context.save()
        }
        catch _{
            
        }
        self.tableView.reloadData()
    }

}

