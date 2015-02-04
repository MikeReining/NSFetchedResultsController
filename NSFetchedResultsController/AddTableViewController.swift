//
//  AddTableViewController.swift
//  NSFetchedResultsController
//
//  Created by Michael Reining on 2/3/15.
//  Copyright (c) 2015 Mike Reining. All rights reserved.
//

import UIKit
import CoreData

// add scene view controller
class AddTableViewController: UITableViewController {
    // custom types for "Cancel" and "Finish" delegates
    typealias DidCancelDelegate = (AddTableViewController) -> ()
    typealias DidFinishDelegate = (AddTableViewController) -> ()
    var didCancel: DidCancelDelegate?
    var didFinish: DidFinishDelegate?
    
    // new model instance
    var item: Item?
    
    // `Item` model `name` attribute source
    @IBOutlet var nameTextField: UITextField!
    
    /* "Cancel" action
    deletes the newly created `Item`
    notifies "Cancel" delegate */
    @IBAction func cancel(sender: AnyObject) {
        // hide keyboard
        nameTextField.resignFirstResponder()
        
        /* delete model
        only _marks_ it for deletion */
        let item = self.item!
        let managedObjectContext = item.managedObjectContext!
        managedObjectContext.deleteObject(item)
        
        /* save `NSManagedObjectContext`
        deletes model from the persistent store (SQLite DB) */
        var e: NSError?
        if !managedObjectContext.save(&e) {
            println("cancel error: \(e!.localizedDescription)")
            abort()
        }
        
        // notify delegate (master list scene view controller)
        self.didCancel!(self)
    }
    
    /* "Done" action
    sets `Item` name and saves it (update)
    notifies "Finish" delegate */
    @IBAction func done(sender: AnyObject) {
        // hide keyboard
        nameTextField.resignFirstResponder()
        
        // set `Item` `name`
        let item = self.item!
        item.name = nameTextField.text
        let managedObjectContext = item.managedObjectContext!
        
        // save `NSManagedObjectContext`
        var e: NSError?
        if !managedObjectContext.save(&e) {
            println("finish error: \(e!.localizedDescription)")
            abort()
        }
        
        // notify delegate (master list scene view controller)
        self.didFinish!(self)
    }
}
