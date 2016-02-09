//
//  ViewController.swift
//  memeMe
//
//  Created by Manson Jones on 2/2/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate
{

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    var topTextFieldInUse: Bool!
    var bottomTextFieldInUse: Bool!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.topTextFieldInUse = false
        self.bottomTextFieldInUse = false
        self.topTextField.tag = 1
        self.bottomTextField.tag = 2
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        // This defines a font that is similar to the typical meme font
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40.0)!,
            NSStrokeWidthAttributeName: -3.0]
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center
        
        // Subscribe to the keyboard notifications, to allow the view to 
        // slide up or down so that the keyboard does not obscure the view
        self.subscribeToKeyboardNotifications()

        shareButton.enabled = memeImageView.image == nil ? false : true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscripeFromKeyboardNotifications()
    }

    @IBAction func launchPhotoPicker(sender: AnyObject) {
        let photoPickerController = UIImagePickerController()
        photoPickerController.delegate = self
        photoPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(photoPickerController, animated: true, completion: nil)
    }
    
    @IBAction func launchCamera(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate Function from UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField.tag {
        case 1:
            if (!self.topTextFieldInUse) {
                textField.text = ""
                self.topTextFieldInUse = true
            }
        case 2:
            if (!self.bottomTextFieldInUse) {
                textField.text = ""
                self.bottomTextFieldInUse = true
            }
        default:
            return
        }
    }
    
    // Dismiss keyboard upon return
    // (Delegate Function from UITextFieldDelegate)
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the view up when the keyboard covers the bottom text field
    func keyboardWillShow(notification: NSNotification) {
        if (self.bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Hide the view down when the keyboard covers the bottom text field
    func keyboardWillHide(notification: NSNotification) {
        if (self.bottomTextField.isFirstResponder()) {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscripeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save() {
        _ = Meme(
            topText: self.topTextField.text,
            bottomText: self.bottomTextField.text,
            image: self.memeImageView.image,
            memedImage: self.memeImageView.image
        )
    }
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        // let image: UIImage = self.memeImageView.image!
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (s:String?, ok:Bool, items: [AnyObject]?, err:NSError?) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navigation bar while rendering meme
        self.bottomToolbar.hidden = true
        self.topNavigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide toolbar and navigation bar now that meme is rendered
        self.bottomToolbar.hidden = false
        self.topNavigationBar.hidden = false
        
        return memedImage
    }
    
}

