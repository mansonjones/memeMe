//
//  ViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/2/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func launchPhotoPicker(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
}

