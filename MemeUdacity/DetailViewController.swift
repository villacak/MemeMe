//
//  DetailViewController.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/19/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var topLabelDetail: UITextField!
    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var bottomLabelDetail: UITextField!
    
    var memeTabBarController: MemeTabBarController?
    var tempMeme: MemeData?
    var selected: Int!
    
    // Meme text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : CGFloat(-3.0)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTabBarController = self.tabBarController as? MemeTabBarController
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        
        // Set delegates
        self.topLabelDetail.delegate = self
        self.bottomLabelDetail.delegate = self
        
        // Set attributes to those two UITextView
        self.topLabelDetail.defaultTextAttributes = memeTextAttributes
        self.bottomLabelDetail.defaultTextAttributes = memeTextAttributes
        
        // Set aligment to center to those two UITextViews
        self.topLabelDetail.textAlignment = NSTextAlignment.Center
        self.bottomLabelDetail.textAlignment = NSTextAlignment.Center
        
        // Make fields readonly
        self.topLabelDetail.enabled = false
        self.bottomLabelDetail.enabled = false
        
        
        self.selected = memeTabBarController!.selectedKey
        
        if memeTabBarController!.memesArray.count > 0 {
            // It may contains just one meme
            if (self.selected == nil) {
                self.selected = 0
            }
            tempMeme = memeTabBarController!.memesArray[self.selected]!
            self.imageViewDetail.image = tempMeme!.imageMemeStored
            self.topLabelDetail.text = tempMeme!.topText
            self.bottomLabelDetail.text = tempMeme!.bottomText
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.hidden = false
//        self.navigationController?.setToolbarHidden(true, animated: false)
        let editor = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        self.navigationController?.pushViewController(editor, animated: true)
        
    }
    
    
    @IBAction func deleteEction(sender: UIBarButtonItem) {
        memeTabBarController!.memesArray.removeAtIndex(self.selected)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
