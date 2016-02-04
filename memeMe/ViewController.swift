//
//  ViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/2/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate
{

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    @IBAction func launchPhotoPicker(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func launchCamera(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    // Under what circumstances would this be called?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Did Finish Picking Image")
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
        print("Did Finish Picking Media")
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Did Cancel Picker Controller")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate Function from UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = "This goes in top and bottom"
    }
    
    // Delegate Function from UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

