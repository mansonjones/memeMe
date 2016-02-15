//
//  MemeCollectionViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/13/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // To Do: figure out if the declaration of the Memes array
    // requires a ! or not
    //   var memes: [Meme]!
    
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Model
    let teams = ["Warriors","Spurs","Thunder","Wizards","Clippers"]
    
    // 
    // let memes =
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "launchMemeEditor")
       
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        // TODO: Determine if this is will provide updated memeinformation,
        // or if it needs to be called in ViewWillAppear.
//        let applicationDelegate = (UIApplication.sharedApplication().delegate as!
//        AppDelegate)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    func launchMemeEditor() {
        // let memeEditorController = MemeTableViewController()
        let memeVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
        MemeEditorViewController
        presentViewController(memeVC, animated: true, completion: nil)
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return self.memes.count
        return teams.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        //let meme = memes[0]
        //let meme = memes[indexPath.item]
    //    cell.setText(meme.top, bottomString: meme.bottom)
        // let imageView = UIImageView(image: meme.image)
        // cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // Grab the MemeEditorVC from the storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController")
        
        let memeEditorVC = object as! MemeEditorViewController
        
        // Populate view controller with data from the selected item
       // memeEditorVC.blah = self.memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(memeEditorVC, animated: true)
    }
}
