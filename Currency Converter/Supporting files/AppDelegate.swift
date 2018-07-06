//
//  AppDelegate.swift
//  Currency Converter
//
//  Created by User on 24.06.2018.
//  Copyright © 2018 FarabiCorporation. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.reachability = Reachability()
        self.reachability.whenReachable = { reachability in
            NotificationCenter.default.post(name: NSNotification.Name("ReachableKey"), object: nil)
        }
        do {
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        return true
    }
}

