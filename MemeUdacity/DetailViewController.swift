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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTabBarController = tabBarController as? MemeTabBarController
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        
        // Set delegates
        topLabelDetail.delegate = self
        bottomLabelDetail.delegate = self
        
        // Set attributes to those two UITextView
        topLabelDetail.defaultTextAttributes = PropertiesListUtil().getTextFieldAttributes()
        bottomLabelDetail.defaultTextAttributes = PropertiesListUtil().getTextFieldAttributes()
        
        // Set aligment to center to those two UITextViews
        topLabelDetail = PropertiesListUtil().getCustomSettingsForTextField(topLabelDetail)
        bottomLabelDetail = PropertiesListUtil().getCustomSettingsForTextField(bottomLabelDetail)
        
        // Make fields readonly
        topLabelDetail.enabled = false
        bottomLabelDetail.enabled = false
        
        
        selected = memeTabBarController!.selectedKey
        
        if memeTabBarController!.memesArray.count > 0 {
            // It may contains just one meme
            if (selected == nil) {
                selected = 0
            }
            tempMeme = memeTabBarController!.memesArray[self.selected]!
            imageViewDetail.image = tempMeme!.imageMemeStored
            topLabelDetail.text = tempMeme!.topText
            bottomLabelDetail.text = tempMeme!.bottomText
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        let editor = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        editor.typeCall = TypeCall.EDIT
        navigationController?.pushViewController(editor, animated: true)
    }
    
    
    @IBAction func deleteEction(sender: UIBarButtonItem) {
        memeTabBarController!.memesArray.removeAtIndex(self.selected)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
