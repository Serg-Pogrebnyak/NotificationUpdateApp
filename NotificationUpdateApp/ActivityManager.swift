//
//  ActivityManager.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
protocol ActivityManagerDelegate: AnyObject {
    func didReceiveNewToken(_ token: String)
}

@available(iOS 16.1, *)
final class ActivityManager {
    
    static let shared = ActivityManager()
    
    weak var delegate: ActivityManagerDelegate?
    
    private init() {
        //no-op
    }
    
    private(set) var activityToken: String?
    private lazy var liveActivity: Activity<NotificationLiveActivityAttributes>? = {
        try? Activity<NotificationLiveActivityAttributes>.request(
            attributes: .init(name: "Some name will be here"),
            contentState: .init(value: 0),
            pushType: .token)
    }()
    
    func startActivity() {
        guard let liveActivity = liveActivity else { return }
        Task {
            for await activityPushToken in liveActivity.pushTokenUpdates {
                activityToken = activityPushToken.hex
                delegate?.didReceiveNewToken(activityPushToken.hex)
            }
        }
    }
}
