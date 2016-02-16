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
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "launchMemeEditor")
     }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // This is required so that the calls to the memes array will succeed
        collectionView!.reloadData()
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillLayoutSubviews() {
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
           let space: CGFloat = 3.0
           let dimension = (view.frame.size.height - (2*space)) / 3.0
            updateFlowLayout(space, lineSpacing: space, dimension: dimension)
         } else {
            let space: CGFloat = 3.0
            let dimension = (view.frame.size.width - (2*space)) / 3.0
            updateFlowLayout(space, lineSpacing: space, dimension: dimension)
         }
    }
    
    func updateFlowLayout(interItemSpacing: CGFloat, lineSpacing: CGFloat, dimension: CGFloat) {
        flowLayout.minimumInteritemSpacing = interItemSpacing
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    func launchMemeEditor() {
        let memeVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
        MemeEditorViewController
        presentViewController(memeVC, animated: true, completion: nil)
    }
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
            let meme = memes[indexPath.row]
            cell.memeImageView.image = meme.memedImage!
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Grab the MemeDetailViewController from Storyboard
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView")
        let detailVC = object as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailVC.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
      }
}
