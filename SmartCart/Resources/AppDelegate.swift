//
//  AppDelegate.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 21/10/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit

internal let logger = Logger()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Properties
    
    private var mainCoordinator: MainViewCoordinator?
    
    // MARK: - Properties
    
    internal var window: UIWindow?
    
    // MARK: - Methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        let assembler = ModuleAssembler()
        mainCoordinator = MainViewCoordinatorImpl(navigationController: navigationController, assembler: assembler)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        mainCoordinator?.showCartList()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) { }
}
