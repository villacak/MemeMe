//
//  ViewController.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    // IBOutlets declaration
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    // Memedata, may be nil
    var memeData: MemeData?
    var selected: Int!
    var imageName: String?
    var typeCall: TypeCall!
    
    var appDelegate: AppDelegate!
    var memeTabBarController: MemeTabBarController!
    
    // Activity View Controller to the share button
    var activityViewController:UIActivityViewController?
    
    
    // View did load, loading values every time view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        memeTabBarController = tabBarController as! MemeTabBarController
        
        // Set attributes to those two UITextView
        topText.defaultTextAttributes = PropertiesListUtil().getTextFieldAttributes()
        bottomText.defaultTextAttributes = PropertiesListUtil().getTextFieldAttributes()
        
        // Hide UITextView
        topText.hidden = true
        bottomText.hidden = true
        shareButton.enabled = false
    }
    
    
    
    // View will appear, load some other settings just before view appear
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        
        // Set properties to FieldViews
        topText = PropertiesListUtil().getCustomSettingsForTextField(topText)
        bottomText = PropertiesListUtil().getCustomSettingsForTextField(bottomText)
        
        // Check if camera exist or not to enable the button
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        
        if (typeCall == TypeCall.EDIT) {
            loadDataToView()
        } 
    }
    
    
    // Close the view - back button as cancel
    func closeView(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    // Clean the image and texts
    @IBAction func cancelAction(sender: AnyObject) {
        imageSelected.image = nil
        imageSelected.contentMode = UIViewContentMode.ScaleAspectFit
        topText.hidden = true
        bottomText.hidden = true
    }
    
    
    func loadDataToView() {
        if let tempMemes = memeTabBarController?.memesArray {
            if let tempKey = memeTabBarController!.selectedKey {
                if tempMemes.count > 0 {
                    memeData = tempMemes[tempKey]
                    selected = tempKey
                    imageSelected.image = memeData!.imageMemeStored
                    topText.text = memeData!.topText
                    bottomText.text = memeData!.bottomText
                    topText.hidden = false
                    bottomText.hidden = false
                    shareButton.enabled = true
                }
            }
        }
    }
    
    
    
    
    // View will disappear, it's when I remove those two keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _:UIImage = imageSelected.image {
            if (topText.text != nil && bottomText.text != nil) {
                save()
            }
        }
        // Call method that remove notification
        unsubscribeFromKeyboardNotifications()
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
        shareButton.enabled = true
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    /*
    * Share button action
    */
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let shareScreen:UIImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [shareScreen], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(type, completed, returnedItems, error) -> Void in
            if completed{
                self.save()
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    
    /*
    * When the user select, this methos is called
    * if the user select any picture from library or camera it will get it
    * load to the image view, close the picker, display those two UITextViews with the
    * image at the center
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageSelected.image = image
        imageSelected.contentMode = UIViewContentMode.ScaleAspectFit
        topText.hidden = false
        bottomText.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // If the user cancel from the picker control we dismiss the image here
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // Delegate when user hit the soft key Done from keyboard, we collapse the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Keyboard notify notification center the keyboard will show
    func keyboardWillShow(notification: NSNotification) {
        if (view.frame.origin.y >= 0 &&
            bottomText.isFirstResponder()) {
                view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    // Keyboard notify notification center the keyboard will hide
    func keyboardWillHide(notification: NSNotification) {
        if (view.frame.origin.y <= 0 &&
            bottomText.isFirstResponder()) {
                view.frame.origin.y += getKeyboardHeight(notification)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)) , name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)) , name:UIKeyboardWillHideNotification, object: nil)
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
    func save() {
        let fileName = PropertiesListUtil().getDateTimeAsString()
        
        memeData = MemeData(topText: topText.text!, bottomText: bottomText.text!, imageMeme: fileName, imageMemeStored: imageSelected.image!)
        
        if let _ = selected {
            memeTabBarController!.memesArray[selected] = memeData
        } else {
            memeTabBarController!.memesArray.append(memeData)
        }
        
        // Once the Object is saved in the array there is no need anymore to keep the variable with values
        // This also help to control the save button
        memeData = nil
        shareButton.enabled = true
    }
    
    
    // Generate the meme image to save as an image and to export!
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navigation bar
//        navigationController?.navigationBarHidden == true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the toolbar
//        navigationController?.navigationBarHidden == false
        
        return memedImage
    }
}