//
//  AppDelegate.swift
//  Cardmoa
//
//  Created by 전수열 on 1/4/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window.backgroundColor = UIColor.whiteColor()
        self.window.makeKeyAndVisible()

        let cardListViewController = CardListViewController()
        let navigationController = UINavigationController(rootViewController: cardListViewController)
        self.window.rootViewController = navigationController
        
        return true
    }

}

