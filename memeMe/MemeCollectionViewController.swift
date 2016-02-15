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
    
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "launchMemeEditor")
       
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
     }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // This is required so that the calls to the memes array will succeed
        self.collectionView!.reloadData()
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
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
            let meme = memes[indexPath.row]
            cell.memeImageView.image = meme.memedImage!
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Grab the MemeDetailViewController from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView")
        let detailVC = object as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailVC.meme = self.memes[indexPath.row]
        
        // Present the view controller using navigation
        self.navigationController!.pushViewController(detailVC, animated: true)

        /*
        // Grab the MemeEditorVC from the storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController")
        
        let memeEditorVC = object as! MemeEditorViewController
        
        // Populate view controller with data from the selected item
       // memeEditorVC.blah = self.memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(memeEditorVC, animated: true)
    */
      }
}
