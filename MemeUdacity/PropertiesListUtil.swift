//
//  PropertiesListUtil.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit
import Foundation

class PropertiesListUtil {
    
    let fileName: String = "memes.plist"
    let fileType: String = "plist"
    let topKey: String = "top"
    let bottomKey: String = "bottom"
    let imageKey: String = "imagePath"
    let keyName: String = "memesKey"
    
    
    /*
    * Generate a name for the image, to be used later for persist it
    */
    func getDateTimeAsString() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM_ddd_yyyy_HH:mm:ss"
        let dateStr: String = dateFormatter.stringFromDate(NSDate())
        return dateStr
    }
    
    
    /*
    * Get entry field new height
    */
    func getCustomSettingsForTextField(textFieldText: UITextField) -> UITextField {
        textFieldText.textAlignment = NSTextAlignment.Center
        textFieldText.clearsOnBeginEditing = true
        return textFieldText
    }
    
    
    /*
     * Get UI TextField Attributes
     */
    func getTextFieldAttributes() -> [NSObject: AnyObject] {
        // Meme text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : CGFloat(-3.0)
        ]
        return memeTextAttributes
    }
    
}
