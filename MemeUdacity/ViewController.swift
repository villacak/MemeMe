//
//  ViewController.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    // IBOutlets declaration
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    //    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // Meme text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : CGFloat(-3.0)
    ]
    
    // Memedata, may be nil
    var memeData: MemeData?
    var imageName: String?
    
    var appDelegate: AppDelegate!
    var memeTabBarController: MemeTabBarController!
    
    // Activity View Controller to the share button
    var activityViewController:UIActivityViewController?
    
    
    // View did load, loading values every time view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memeTabBarController = self.tabBarController as! MemeTabBarController
        
        // Set attributes to those two UITextView
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        
        // Hide UITextView
        self.topText.hidden = true
        self.bottomText.hidden = true
        
        // Disable Save button
        self.saveButton.enabled = false
    }
    
    
    
    // View will appear, load some other settings just before view appear
    override func viewWillAppear(animated: Bool) {
        // Set those two UITextViews to clear the text when on begin editing
        self.topText.clearsOnBeginEditing = true
        self.bottomText.clearsOnBeginEditing = true
        
        // Set aligment to center to those two UITextViews
        self.topText.textAlignment = NSTextAlignment.Center
        self.bottomText.textAlignment = NSTextAlignment.Center
        
        // Check if camera exist or not to enable the button
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        
        loadDataToView()
    }
    
    
    
    func loadDataToView() {
        
        if let tempMemes = memeTabBarController.memesArray as? [MemeData!] {
            if let tempKey = memeTabBarController!.selectedKey {
                if tempMemes.count > 0 {
                    self.memeData = tempMemes[tempKey]
                    self.imageSelected.image = self.memeData!.imageMemeStored
                    self.topText.text = self.memeData!.topText
                    self.bottomText.text = self.memeData!.bottomText
                    self.topText.hidden = false
                    self.bottomText.hidden = false
                }
            }
        }
    }
    
    
    
    
    // View will disappear, it's when I remove those two keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Call method that remove notification
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    
    /*
    * Action for both buttons when user tap on it
    * The action check what button is calling and select the right source type
    * and lunch it
    */
    @IBAction func pickImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if let text = sender.image?.description {
            if text == "galleryButton" {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            } else if text == "cameraButton" {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            }
        }
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    /*
    * Share button action
    */
    @IBAction func shareAction(sender: UIButton) {
        let shareScreen:UIImage = generateMemedImage()
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [shareScreen], applicationActivities: nil)
        let presentationController = activityViewController.popoverPresentationController
        presentationController?.sourceView = sender
        presentationController?.sourceRect = CGRect(origin: CGPointZero, size: CGSize(width: sender.frame.width, height: sender.frame.height))
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    
    /*
    * When the user select, this methos is called
    * if the user select any picture from library or camera it will get it
    * load to the image view, close the picker, display those two UITextViews with the
    * image at the center
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageSelected.image = image
        imageSelected.contentMode = UIViewContentMode.ScaleToFill
        self.topText.hidden = false
        self.bottomText.hidden = false
        checkSaveButton()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // If the user cancel from the picker control we dismiss the image here
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // Delegate when user hit the soft key Done from keyboard, we collapse the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkSaveButton()
        return true
    }
    
    
    // Keyboard notify notification center the keyboard will show
    func keyboardWillShow(notification: NSNotification) {
        if (self.view.frame.origin.y >= 0 &&
            self.bottomText.isFirstResponder()) {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    // Keyboard notify notification center the keyboard will hide
    func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y <= 0 &&
            self.bottomText.isFirstResponder()) {
                self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    
    // Get the keyboard hieght to move the to be hidden UITextView
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height + 10
    }
    
    
    /*
    * Subscribe methods keyboardWillShow and keyboardWillHide to the notification center
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /*
    * Unsubscribe methods keyboardWillShow and keyboardWillHide from the notification center
    */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    // Save the meme, at moment just in memory
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let fileName = PropertiesListUtil().getDateTimeAsString()
        memeData = MemeData(topText: self.topText.text!, bottomText: self.bottomText.text!, imageMeme: fileName, imageMemeStored: self.imageSelected.image!)
        memeTabBarController!.memesArray.append(memeData)
        //        (self.tabBarController as! MemeTabBarController).memesArray.append(memeData)
        
        // Once the Object is saved in the array there is no need anymore to keep the variable with values
        // This also help to control the save button
        memeData = nil
        self.saveButton.enabled = false
    }
    
    
    // Generate the meme image to save as an image and to export!
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navigation bar
        self.navigationController?.navigationBarHidden == true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the toolbar
        self.navigationController?.navigationBarHidden == false
        
        return memedImage
    }
    
    
    // Check if enable or disable the save button
    func checkSaveButton() {
        if (self.memeData != nil) {
            self.saveButton.enabled = false
        } else {
            self.saveButton.enabled = true
        }
        
    }
}