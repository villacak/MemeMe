//
//  MemeData.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


struct MemeData {
    
    var topText: String?
    var bottomText: String?
    var imageMeme: String?
    var imageMemeStored: UIImage
    
    init() {
        self.topText = ""
        self.bottomText = ""
        self.imageMeme = ""
        self.imageMemeStored = UIImage()
    }
    
    init(topText: String, bottomText: String, imageMeme: String, imageMemeStored: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.imageMeme = imageMeme
        self.imageMemeStored = imageMemeStored
    }
    
}
//class MemeData: NSObject {
//
//    var topText: String?
//    var bottomText: String?
//    var imageMeme: String?
//    var imageMemeStored: UIImage
//
//    override init() {
//        self.topText = ""
//        self.bottomText = ""
//        self.imageMeme = ""
//        self.imageMemeStored = UIImage()
//    }
//
//
//    init(topText: String, bottomText: String, imageMeme: String, imageMemeStored: UIImage) {
//        self.topText = topText
//        self.bottomText = bottomText
//        self.imageMeme = imageMeme
//        self.imageMemeStored = imageMemeStored
//    }
//}
