//
//  AppDelegate.swift
//  ToDoey
//
//  Created by User on 2019/4/2.
//  Copyright © 2019 Frank Ding. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        do{
            _ = try Realm()
        }catch{
            print("\(error)")
        }
        // Override point for customization after application launch.
        
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        return true
    }
}

