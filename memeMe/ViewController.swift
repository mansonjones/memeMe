//
//  ViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/2/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func launchPhotoPicker(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Did Finish Picking Image")
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Did Finish Picking Media")
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Did Cancel Picker Controller")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

