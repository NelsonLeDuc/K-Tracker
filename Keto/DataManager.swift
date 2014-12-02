//
//  DataManager.swift
//  Keto
//
//  Created by Nelson LeDuc on 12/1/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

import Foundation

@objc
class DataManager
{
    
    class func savedDataArray() -> [AnyObject]
    {
        let arr = NSUserDefaults.standardUserDefaults().arrayForKey("dataArray")
        
        return arr ?? []
    }
    
    class func saveDataArray(dataArray: [AnyObject])
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(dataArray, forKey: "dataArray")
        userDefaults.synchronize()
    }
    
}