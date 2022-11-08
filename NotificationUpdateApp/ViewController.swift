//
//  ViewController.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit
import ActivityKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.1, *) {
            startLiveActivity()
        }
    }

    @available(iOS 16.1, *)
    private func startLiveActivity() {
        let staticContent = NotificationLiveActivityAttributes(name: "Some name will be here")
        
        do {
            let deliveryActivity = try Activity<NotificationLiveActivityAttributes>.request(
                attributes: staticContent,
                contentState: .init(value: 0),
                pushType: .token)
            Task {
                for await activityPushToken in deliveryActivity.pushTokenUpdates {
                    print("live activity token: \(activityPushToken.hex)")
                }
            }
        } catch (let error) {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }
}


