//
//  MemeDetailViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/15/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .Edit , target: self, action: "launchMemeEditor")
        super.viewWillAppear(animated)
        memeImageView!.image = meme.memedImage
        memeImageView.contentMode = .ScaleAspectFit
    }
    
    func launchMemeEditor() {
        let memeVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as!
        MemeEditorViewController
        
        memeVC.inputMeme = meme
        presentViewController(memeVC, animated: true, completion: nil)
        
    }
    
}
