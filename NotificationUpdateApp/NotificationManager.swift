//
//  NotificationManager.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit

final class NotificationManager: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let application: UIApplication
    
    init(application: UIApplication = .shared) {
        self.application = application
        super.init()
    }
    
    func registerForRemoteNotifications(_ application: UIApplication) {
        notificationCenter.delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(options: authOptions) { granted, _ in
            guard granted else { return }
            //no-op
        }

        application.registerForRemoteNotifications()
    }
    
    func registerToken(deviceToken: Data) {
        print("\(self).token is: ", deviceToken.hex)
    }
    
    func handle(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], openAppFromPush: Bool = false, completion: @escaping (UIBackgroundFetchResult) -> Void = {_ in }) {
        print("\(self).didReceiveRemoteNotification: \(userInfo)")
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    //NOTE: Method handled when notification received when an application in foreground state, we do not display any banner to user
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let body = notification.request.content.userInfo
        handle(application, didReceiveRemoteNotification: body)
        if #available(iOS 14.0, *) {
            completionHandler([.banner])
        } else {
            completionHandler([.alert])
        }
    }

    //NOTE: Method get called when user tap on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let body = response.notification.request.content.userInfo
        handle(application, didReceiveRemoteNotification: body)
        completionHandler()
    }
}
