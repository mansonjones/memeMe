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
    // Model
    let teams = ["Warriors","Spurs","Thunder","Wizards","Clippers"]
    
    // TODO: decide which approach is better
    // var memes = [Meme]()
    // WTF: not sure if the following line should look like this
    // var memes: [Meme]!
    // or
    // var memes: [Meme]
    // There are different version in the course notes and
    // videos
    
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
    
  /*
    func updateMemes() {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as!
            AppDelegate)
        print(memes.count)
        if (memes.count > 0) {
            print(memes[0].topText)
            print(memes[0].bottomText)
        }
        
    }
   */
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("From number of Rows")
        print(memes.count)
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        print("cellForRowAtIndexPath")
        
        cell.textLabel?.text = self.memes[indexPath.row].topText!
      //  cell.textLabel?.text = "ABC"
        //cell.imageView?.image = UIImage(named: self.memes[indexPath.row].memedImage
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
