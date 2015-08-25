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
    
    // I have this var for when I go persist those images in a plist file, then I have the
    // getTImeAsString that will produce the file name, with this I can Edit the old memes,
    // even that after edit and saved, it will be a new meme image stored. At least the user
    // can still have edition capabilities on memes, and also I was planning load up all those
    // previously saved memes.
    // Due the change from class to struct, I had to remove those methods com Properties Util,
    // then it become deprecated, though I plan to add it back.
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
