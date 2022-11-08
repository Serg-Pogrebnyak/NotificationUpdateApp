//
//  NotificationLiveActivityAttributes.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 08.11.2022.
//

import Foundation
import ActivityKit

struct NotificationLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
