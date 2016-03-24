//
//  Diary.swift
//  FinalProject
//
//  Created by TangZekun on 8/2/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import UIKit
import CoreData

class Diary: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, LocationDelegate,UITextFieldDelegate
{
    
   
    @IBOutlet weak var saveBtnAble: UIBarButtonItem!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textViewContent: UITextView!
    
    var selectedImage: UIImage!
    var existingItem : DiaryEntry!
    {
        didSet
        {
            
            if let data = existingItem.picture
            {
                selectedImage = UIImage(data: data)
            }
            else
            {
                selectedImage = nil
            }
            
            locationValue = existingItem.geograph.location
        }
    }
    var locationValue: String?

    
    func location(location: Location, didUpdateWithValue value: String?) {
        locationValue = value
    }
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (existingItem != nil)
        {
            println("ENTER")
            textFieldName.text = existingItem.diaryname
            textViewContent.text = existingItem.content
        }
        
        updateSaveButtonStateForText(textFieldName.text)
    }
    
    
    private func updateSaveButtonStateForText(text: String) {
        if !text.isEmpty
        {
            saveBtnAble.enabled = true
        }
        else {
            saveBtnAble.enabled = false
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 2 {
            if indexPath.row == 0
            {
                var photo = UIImagePickerController()
                photo.delegate = self
                photo.sourceType = .PhotoLibrary
                self.presentViewController(photo, animated: true, completion: nil)
                
            }
            
            view.endEditing(true)
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let theInfo : NSDictionary = info as NSDictionary
        selectedImage = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    @IBAction func saveTapped(sender: AnyObject)
    {
        
        // reference to our app delegate
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // reference Model
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("DiaryEntry", inManagedObjectContext: context)
        
        var formatter: NSDateFormatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        formatter.dateFormat = "MM/dd/YYYY HH:mm:ss"
        let dateTimePrefix: String = formatter.stringFromDate(NSDate())
        
        //check if item exists
        if (existingItem != nil)
        {
            existingItem.diaryname = textFieldName.text
            existingItem.content   = textViewContent.text
            existingItem.date      = dateTimePrefix
            
            let imageData = UIImageJPEGRepresentation(selectedImage, 0.9)
            existingItem.picture = imageData
            
            existingItem.geograph.location = locationValue
            println("Value changed to : \(existingItem)")
            
            context.save(nil)
            
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            // create instance of our data and initializ
            var newItem = DiaryEntry(entity : en!, insertIntoManagedObjectContext : context)
            
            // map our property

                
                let imageData = UIImageJPEGRepresentation(selectedImage, 0.9)
                
                newItem.picture = imageData
                newItem.diaryname = textFieldName.text
                newItem.content   = textViewContent.text
                newItem.date      = dateTimePrefix
                
                let geograph = NSEntityDescription.insertNewObjectForEntityForName("Geograph", inManagedObjectContext: context) as! Geograph
                geograph.location = locationValue
                geograph.diaryentry = newItem                
                
                println(dateTimePrefix)
                println(newItem.diaryname)
                println(newItem.content)
                
                
                // save our content
                context.save(nil)
                println("New Diary")
                // navigate back to view controller
                self.dismissViewControllerAnimated(true, completion: nil)
                //self.navigationController?.popViewControllerAnimated(true)
                //self.navigationController?.popToRootViewControllerAnimated(true)
                //performSegueWithIdentifier("saveSegue", sender: sender)
            //}
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popViewControllerAnimated(true)
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        performSegueWithIdentifier("cancelSegue", sender: sender)

    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if existingItem != nil
        {
            navigationItem.leftBarButtonItem = nil
        }
        
        
//        if textFieldName.text != nil
//        {
//            println("viewWillAppeartextFieldName.text:  \(textFieldName)")
//          self.saveBtnAble.enabled = true
//        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier where identifier == "LocationSegue" {
            let location = segue.destinationViewController as! Location
            location.delegate = self
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newValue = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        updateSaveButtonStateForText(newValue)
        
        return true
    }
}
