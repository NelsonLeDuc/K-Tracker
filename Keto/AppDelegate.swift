//
//  AppDelegate.swift
//  Keto
//
//  Created by Nelson LeDuc on 12/1/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        createRootViewController()
        
        return true
    }
    
    private func createRootViewController()
    {
        let containerViewController = KTARootViewController()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = containerViewController
        self.window?.makeKeyAndVisible()
    }
    
}