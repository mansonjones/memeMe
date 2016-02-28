//
//  MemeTableViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/13/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "launchMemeEditor")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // The next line is required so that the memes array will be accessible.
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")!
        
        cell.textLabel?.text = memes[indexPath.row].topText! + " / " + memes[indexPath.row].bottomText!
        cell.imageView?.image = memes[indexPath.row].memedImage!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Grab the MemeDetailViewController from Storyboard
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView")
        let detailVC = object as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailVC.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.memes.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
    }
    
    func launchMemeEditor() {
        let memeVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
        MemeEditorViewController
        presentViewController(memeVC, animated: true, completion: nil)
    }
}
