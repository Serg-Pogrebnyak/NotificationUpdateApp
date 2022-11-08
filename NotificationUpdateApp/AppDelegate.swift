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
    let notificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
