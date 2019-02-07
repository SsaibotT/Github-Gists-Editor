//
//  AppDelegate.swift
//  Github Gists Editor
//
//  Created by Serhii on 11/22/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabController = UITabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabController
        
        print(GistsViewController.identifier)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let firstGistAuthors  = storyBoard
            .instantiateViewController(withIdentifier: GistsViewController.identifier)
            as? GistsViewController else { return true }
        guard let secondGistAuthors = storyBoard
            .instantiateViewController(withIdentifier: GistsViewController.identifier)
            as? GistsViewController else { return true }
        
        firstGistAuthors.tabBarItem  = UITabBarItem(title: "public", image: UIImage(named: "public"), tag: 0)
        secondGistAuthors.tabBarItem = UITabBarItem(title: "private", image: UIImage(named: "person"), tag: 1)
        
        firstGistAuthors.isPublic = true
        secondGistAuthors.isPublic = false
        
        let tabBarList = [firstGistAuthors, secondGistAuthors]
        tabController.viewControllers = tabBarList.map { return UINavigationController(rootViewController: $0) }
        
        // Realm configuration if scheme changes
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 14,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}
