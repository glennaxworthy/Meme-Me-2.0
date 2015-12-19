//
//  MemeData.swift
//  MemeMe
//
//  Created by Glenn Axworthy on 12/11/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

struct MemeData {
    var meme: UIImage! = nil
    var image: UIImage! = nil
    var top: String! = nil
    var bottom: String! = nil

    static var array: [MemeData] = [MemeData]()

    init() {
        meme = nil
        image = nil
        top = nil
        bottom = nil
    }

    init(meme: UIImage, image: UIImage, top: String, bottom: String) {
        self.meme = meme
        self.image = image
        self.top = top
        self.bottom = bottom
    }

    static func load() {
        array.removeAll()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let nsarray = userDefaults.arrayForKey("SavedMemes")
        if nsarray != nil {
            for dictionary in nsarray! {
                var memeData = MemeData()
                memeData.meme = UIImage(data: dictionary.objectForKey("meme") as! NSData)
                memeData.image = UIImage(data: dictionary.objectForKey("image") as! NSData)
                memeData.top = dictionary.objectForKey("top") as! String
                memeData.bottom = dictionary.objectForKey("bottom") as! String
                array.append(memeData)
            }
        }
    }

    static func save() {
        let nsarray = NSMutableArray()
        for memeData in array {
            let dictionary = NSMutableDictionary()
            dictionary.setObject(UIImagePNGRepresentation(memeData.meme)!, forKey: "meme")
            dictionary.setObject(UIImagePNGRepresentation(memeData.image)!, forKey: "image")
            dictionary.setObject(memeData.top, forKey: "top")
            dictionary.setObject(memeData.bottom, forKey: "bottom")
            nsarray.addObject(dictionary)
        }

        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nsarray, forKey: "SavedMemes")
        userDefaults.synchronize()
    }
}
