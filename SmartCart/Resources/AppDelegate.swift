//
//  AppDelegate.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 21/10/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

internal let logger = Logger()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Properties
    
    private var mainCoordinator: MainViewCoordinator?
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Internal Properties
    
    internal enum NotificationType: String {
        case openCart
        case delete
    }
    
    internal var window: UIWindow?
    
    // MARK: - Methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setupNotifications()

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
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLCircularRegion else { return }
        
        scheduleNotification(forRegion: region)
    }
}

// MARK: - Setup Notification
private extension AppDelegate {
    func setupNotifications() {
        locationManager.delegate = self
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            guard !granted else { return }
            
            logger.logInfo(message: "User does not grant the notification permissions.")
        }
    }
    
    func scheduleNotification(forRegion region: CLRegion) {
        let snoozeAction = UNNotificationAction(
            identifier: NotificationType.openCart.rawValue,
            title: "Open Cart",
            options: [.foreground])
        
        let deleteAction = UNNotificationAction(
            identifier: NotificationType.delete.rawValue,
            title: "Delete",
            options: [.destructive])
        
        let category = UNNotificationCategory(
            identifier: "User Actions",
            actions: [snoozeAction, deleteAction],
            intentIdentifiers: [],
            options: [])
        
        notificationCenter.setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "Available Cart"
        content.body = "You are close to the selected market. In the past, you have created cart with some products. Would you like to open the cart?"
        content.sound = .default
        content.categoryIdentifier = "User Actions"
        
        let request = UNNotificationRequest(
            identifier: region.identifier,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 2,
                repeats: false))
        
        notificationCenter.add(request) { error in
            guard let error = error else { return }
            
            logger.logError(message: error.localizedDescription)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier, NotificationType.openCart.rawValue:
            mainCoordinator?.notifyLastCart()
            
        default:
            logger.logError(message: "Did receive unknown action.")
        }
        
        completionHandler()
    }
}
