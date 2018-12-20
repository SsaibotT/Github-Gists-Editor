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
        guard let firstGistAutors  = storyBoard
            .instantiateViewController(withIdentifier: GistsAutorsTableViewController.identifier)
            as? GistsAutorsTableViewController else { return true }
        
        guard let secondGistAutors = storyBoard
            .instantiateViewController(withIdentifier: GistsAutorsTableViewController.identifier)
            as? GistsAutorsTableViewController else { return true }
        
        firstGistAutors.tabBarItem  = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        secondGistAutors.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        firstGistAutors.publicBool = true
        secondGistAutors.publicBool = false
        
        let tabBarList = [firstGistAutors, secondGistAutors]
        tabController.viewControllers = tabBarList.map { return UINavigationController(rootViewController: $0) }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}
