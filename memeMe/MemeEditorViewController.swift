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
        
        view.backgroundColor = UIColor.darkGrayColor()
        setupTextField(topTextField, defaultText: "TOP")
        setupTextField(bottomTextField, defaultText: "BOTTOM")
        topTextFieldInUse = false
        bottomTextFieldInUse = false
        
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    func setupTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        
        textField.delegate = self
        textField.defaultTextAttributes = MemeConstants.FontStyles.Meme
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // Subscribe to the keyboard notifications, to allow the view to 
        // slide up or down so that the keyboard does not obscure the view
        subscribeToKeyboardNotifications()

        shareButton.enabled = memeImageView.image == nil ? false : true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscripeFromKeyboardNotifications()
    }

    override func viewWillLayoutSubviews() {
       let toolBarWidth = bottomToolbar.frame.width
        bottomToolbar.items![0].width = CGFloat(0.3 * toolBarWidth)
        bottomToolbar.items![1].width = CGFloat(0.1 * toolBarWidth)
        bottomToolbar.items![2].width = CGFloat(0.3 * toolBarWidth)
    }
    
    @IBAction func launchPhotoPicker(sender: AnyObject) {
        let photoPickerController = UIImagePickerController()
        photoPickerController.delegate = self
        photoPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(photoPickerController, animated: true, completion: nil)
    }
    
    @IBAction func launchCamera(sender: AnyObject) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(cameraController, animated: true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
             memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate Function from UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Delegate Function from UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField {
            if (!topTextFieldInUse) {
                textField.text = ""
                topTextFieldInUse = true
            }
        } else if textField == bottomTextField {
            if (!bottomTextFieldInUse) {
                textField.text = ""
                bottomTextFieldInUse = true
            }
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
        if (bottomTextField.isFirstResponder()) {
            // There is a
            
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // Hide the view down when the keyboard covers the bottom text field
    func keyboardWillHide(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()) {
            view.frame.origin.y = 0
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
    
    // Create a meme object and add it to the memes array
    func save(memedImage: UIImage) {
        
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            image: memeImageView.image,
            memedImage: memedImage
        )
        // Add it to the memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        let count = (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
        print(" THE COUNT IS:")
        print(count)
    }
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (s:String?, ok:Bool, items: [AnyObject]?, err:NSError?) -> Void in
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navigation bar while rendering meme
        bottomToolbar.hidden = true
        topNavigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide toolbar and navigation bar now that meme is rendered
        bottomToolbar.hidden = false
        topNavigationBar.hidden = false
        
        return memedImage
    }
    
}

