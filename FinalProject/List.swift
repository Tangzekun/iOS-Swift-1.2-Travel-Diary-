//
//  List.swift
//  FinalProject
//
//  Created by TangZekun on 8/2/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import UIKit
import CoreData

class List: UITableViewController {
    
    var myList: Array<AnyObject> = []
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
        let freq = NSFetchRequest(entityName: "DiaryEntry")
        //fetchedResultsController = NSFetchedResultsController(fetchRequest: freq, managedObjectContext: contxt, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultsController?.delegate = self
        myList = context.executeFetchRequest(freq, error: nil)!
        tableView.reloadData()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        //if let ip = indexPath
        if let ip = indexPath as NSIndexPath?
        {
            var data : NSManagedObject = myList[ip.row] as! NSManagedObject
            cell.textLabel!.text = data.valueForKeyPath("diaryname") as? String
            cell.detailTextLabel?.text = data.valueForKeyPath("date") as? String
            
            /*var qnt  = data.valueForKey("quantity") as! String
            var inf = data.valueForKey("info") as! String
            
            cell.detailTextLabel?.text = "\(qnt) items - \(inf)"*/
        }
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            if let tv = tableView as UITableView?
            {
                context.deleteObject(myList[indexPath.row] as! NSManagedObject)
                myList.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
            var  error : NSError? = nil
            if !context.save(&error)
            {
                abort()
            }
        }
    
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier where identifier == "LookupSegue"
        {
            var selectedItem = myList[self.tableView.indexPathForSelectedRow()!.row] as! DiaryEntry
            
            let IVC = segue.destinationViewController as! FinalVersion
            IVC.selectedDiaryEntry = selectedItem
            
        }
    }
    

}
