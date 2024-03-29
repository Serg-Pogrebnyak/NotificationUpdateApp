//
//  AppDelegate.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let notificationManager = NotificationManager()
    
    private lazy var bleListVC: BLEListVC = {
        let bleListVC: BLEListVC = UIStoryboard(name: "Main", bundle: nil).viewController()
        bleListVC.notificationManager = notificationManager
        return bleListVC
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = UINavigationController(rootViewController: bleListVC)
        self.window = window
        notificationManager.registerForRemoteNotifications(application)
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let openedFromPush = application.applicationState == .inactive || application.applicationState == .background
        notificationManager.handle(application,
                                   didReceiveRemoteNotification: userInfo,
                                   openAppFromPush: openedFromPush,
                                   completion: completionHandler)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationManager.registerToken(deviceToken: deviceToken)
    }
}
