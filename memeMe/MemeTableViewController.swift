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
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "launchMemeEditor")
        self.navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: "test1")
        // self.tableView.reloadData()
        print(" the number of memes is:")
        print(memes.count)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do not remove this next line!
        self.tableView.reloadData()
        print("*** MemeTableViewController: viewWillAppear")
        print("the count = ", memes.count)
        for (var i = 0; i < memes.count; i++) {
            print(memes[i].topText!)
            print(memes[i].bottomText!)
        }
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("From number of Rows")
        print(memes.count)
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        print("cellForRowAtIndexPath")
        
        cell.textLabel?.text = memes[indexPath.row].topText! + " / " + memes[indexPath.row].bottomText!
        cell.imageView?.image = memes[indexPath.row].memedImage!
      
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print(" didSelectRowAtIndexPath")
        let memeVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
            MemeEditorViewController
        // Note: I will want to pass the meme into the MemeEditor.  Something like this:
        // memeVC.meme = self.memes[indexPath.row]
        // Or, I could just pass the index in, since the
        // memes array is available globally.
        self.navigationController!.pushViewController(memeVC, animated: true)
    }

    func launchMemeEditor() {
        // let memeEditorController = MemeTableViewController()
        let memeVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
            MemeEditorViewController
        presentViewController(memeVC, animated: true, completion: nil)
    }
    
    func test1() {
        print(" ----- Test1 -----")
    }
    
    
    
    
}
