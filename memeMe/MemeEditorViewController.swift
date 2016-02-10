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
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextFieldInUse = false
        bottomTextFieldInUse = false
        topTextField.tag = 1
        bottomTextField.tag = 2
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        // This defines a font that is similar to the typical meme font
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40.0)!,
            NSStrokeWidthAttributeName: -3.0]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
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
        print(" viewWillLayoutSubviews")
        // Get the dimensions of the toolbar
        // Get the list of items on the toolbar
        var tempList = bottomToolbar.items
        print(" Bar Button Items Begin")
        let toolBarWidth = bottomToolbar.frame.width
        print(" tool bar width = ", toolBarWidth)
        for (var i = 0; i < tempList!.count; i++) {
            print(tempList![i].width)
        }
        bottomToolbar.items![0].width = CGFloat(0.3 * toolBarWidth)
        bottomToolbar.items![1].width = CGFloat(0.1 * toolBarWidth)
        bottomToolbar.items![2].width = CGFloat(0.3 * toolBarWidth)
        print("Bar Button Items End")
        // TODO: Reposition the bar button items
        // Get the lower toolbar
        
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
            print("image info")
            print(image.size.width, image.size.height)
            memeImageView.image = image
            let width = memeImageView.image?.size.width
            print(width)
            let height = memeImageView.image?.size.height
            print(height)
            topTextField.topAnchor.constraintEqualToAnchor(memeImageView.topAnchor, constant: 50).active = true
            bottomTextField.bottomAnchor.constraintEqualToAnchor(memeImageView.bottomAnchor, constant: -50).active = true
            
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
            if (!topTextFieldInUse) {
                textField.text = ""
                topTextFieldInUse = true
            }
        case 2:
            if (!bottomTextFieldInUse) {
                textField.text = ""
                bottomTextFieldInUse = true
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
        if (bottomTextField.isFirstResponder()) {
            view.frame.origin.y -= getKeyboardHeight(notification)
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
    
    func save() {
        _ = Meme(
            topText: topTextField.text,
            bottomText: bottomTextField.text,
            image: memeImageView.image,
            memedImage: memeImageView.image
        )
    }
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (s:String?, ok:Bool, items: [AnyObject]?, err:NSError?) -> Void in
            self.save()
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

