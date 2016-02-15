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
        super.viewWillAppear(animated)
        self.memeImageView!.image = meme.memedImage
        
        // self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // self.tabBarController?.tabBarController.hidden = false
    }
}
