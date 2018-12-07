//
//  AppDelegate.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/22/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabController = UITabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabController
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let firstGistAutors  = storyBoard
            .instantiateViewController(withIdentifier: GistsAutorsTableViewController.identifier)
        
        let secondGistAutors = storyBoard
            .instantiateViewController(withIdentifier: GistsAutorsTableViewController.identifier)
        
        let firstViewController  = firstGistAutors
        let secondViewController = secondGistAutors
        
        firstViewController.tabBarItem  = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        let tabBarList = [firstViewController, secondViewController]
        tabController.viewControllers = tabBarList.map { return UINavigationController(rootViewController: $0) }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}
