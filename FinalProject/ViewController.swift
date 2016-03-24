//
//  ViewController.swift
//  FinalProject
//
//  Created by TangZekun on 7/27/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    @IBOutlet weak var Password: UITextField!
    //@IBOutlet var Password: UITextField!
    //@IBOutlet private weak var Registerbutton: UIButton!
    @IBOutlet weak var Registerbutton: UIButton!
    
    
    
    @IBAction func btnRegister() {
    //@IBAction func btnRegister()
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        /* var check = NSFetchRequest(entityName: "FirstScene")
        check.returnsObjectsAsFaults = false
        check.predicate = NSPredicate(format: "password = %@", "" + Password.text)
        
        var results: NSArray = context.executeFetchRequest(check, error: nil)!
        
        if(results.count == 0)
        {*/
        var newPassword = NSEntityDescription.insertNewObjectForEntityForName("FirstScene", inManagedObjectContext: context) as! NSManagedObject
        if (Password.text != "")
        {
            newPassword.setValue("" + Password.text, forKey: "password")
            context.save(nil)
            
            println(newPassword)
            println("NewPassword")
            Registerbutton.enabled = false
        }
        else
        {
            println("Password cannot be empty!")
        }
    }
    
    
    
    //@IBAction func btnLogin(sender: AnyObject)
    //@IBAction func btnLogin()
    @IBAction func btnLogin() {
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        var newPassword = NSFetchRequest(entityName: "FirstScene")
        
        newPassword.returnsObjectsAsFaults = false
        newPassword.predicate = NSPredicate(format: "password = %@", "" + Password.text)
        
        
        var results: NSArray = context.executeFetchRequest(newPassword, error: nil)!
        
        /*if(results.count > 0)
        {
        //var res = results[0] as! NSManagedObject
        //Password.text = res.valueForKey("password") as! String
        for pswr in results
        {
        var thispswr = pswr as! Protect
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("login", sender: nil)
        println("Correct")
        }
        }*/
        
        if(results.count > 0)
        {
            var res = results[0] as! NSManagedObject
            if (Password.text == res.valueForKey("password") as? String)
            {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("LoginSegue", sender: nil)
                println("Correct")
            }
        }
        else
        {
            println("Wrong Password")
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        var newPassword = NSFetchRequest(entityName: "FirstScene")
        newPassword.returnsObjectsAsFaults = false
        var results: NSArray = context.executeFetchRequest(newPassword, error: nil)!
        
        if(results.count > 0)
        {
            Registerbutton.enabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

