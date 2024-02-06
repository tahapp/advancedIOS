//
//  AppDelegate.swift
//  Bouncer
//
//  Created by ben hussain on 10/23/23.
//

import UIKit
import CoreMotion
@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    /* everyone who will use my app will ask the appdelegate fro the motion mananger. that way thay all will be using the
     same one. i could have place my manager outside the delegate but here i want to expilictly says that when yuou are in the this app
     this where this app gets it motion manager. */
    struct Motion
    {
        static let manager = CMMotionManager()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

