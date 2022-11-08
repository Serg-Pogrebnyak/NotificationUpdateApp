//
//  NotificationLiveActivityLiveActivity.swift
//  NotificationLiveActivity
//
//  Created by Serhii on 08.11.2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NotificationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NotificationLiveActivityAttributes.self) { context in
            VStack(spacing: 10) {
                Text("Hello \(context.attributes.name)")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(context.state.value.description)
                    .contentTransition(.numericText())
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
