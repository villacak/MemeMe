//
//  PropertiesListUtil.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import Foundation

class PropertiesListUtil {
    
    let fileName: String = "memes.plist"
    let fileType: String = "plist"
    let topKey: String = "top"
    let bottomKey: String = "bottom"
    let imageKey: String = "imagePath"
    let keyName: String = "memesKey"
    
    
    /*
    * Write SWIFT Array to properties list file (plist)
    */
    func writeMemesToPlist(memesArray: [MemeData]) {
        let memesNSArray: NSMutableArray = NSMutableArray(array: memesArray)
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        var dict: NSMutableDictionary = NSMutableDictionary()
        
        for memeDataValue in memesNSArray {
            let metaDataTemp: MemeData = memeDataValue as! MemeData
            dict.setObject(metaDataTemp.topText!, forKey: topKey)
            dict.setObject(metaDataTemp.bottomText!, forKey: bottomKey)
            dict.setObject(metaDataTemp.imageMeme!, forKey: imageKey)
        }
        dict.writeToFile(path, atomically: false)
    }
    
    
    /*
    * Read SWIFT Array to properties list file (plist)
    */
    func readMemesFromPlist() -> [MemeData?]! {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        //        let fileManager = NSFileManager.defaultManager()
        
        if let bundlePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType) {
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
        }
        
        var arrayToReturn: [MemeData?]!
        if let dict = NSDictionary(contentsOfFile: path) {
            arrayToReturn = [MemeData?]()
            var memeDataTemp: MemeData!
            for memeDataValue in dict {
                if memeDataValue.key as! String == topKey {
                    memeDataTemp.topText = memeDataValue.value as? String
                    arrayToReturn.append(memeDataTemp)
                } else if memeDataValue.key as! String  == bottomKey {
                    memeDataTemp = MemeData()
                    memeDataTemp.bottomText = memeDataValue.value as? String
                } else if memeDataValue.key as! String  == imageKey {
                    memeDataTemp.imageMeme = memeDataValue.value as? String
                }
            }
            if let nsArray: NSArray = dict.objectForKey(keyName) as? NSArray {
                arrayToReturn = (nsArray as? [MemeData])!
            }
        }
        return arrayToReturn
    }
    
    
    func getDateTimeAsString() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM_ddd_yyyy_HH:mm:ss"
        let dateStr: String = dateFormatter.stringFromDate(NSDate())
        return dateStr
    }
}
