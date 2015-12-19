//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Glenn Axworthy on 12/11/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        MemeData.load()
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        MemeData.save()
    }
}

