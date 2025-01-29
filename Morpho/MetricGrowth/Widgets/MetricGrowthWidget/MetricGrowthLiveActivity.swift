//
//  MetricGrowthLiveActivity.swift
//  MetricGrowth
//
//  Created by Oscar on 18/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MetricGrowthAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MetricGrowthLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MetricGrowthAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MetricGrowthAttributes {
    fileprivate static var preview: MetricGrowthAttributes {
        MetricGrowthAttributes(name: "World")
    }
}

extension MetricGrowthAttributes.ContentState {
    fileprivate static var smiley: MetricGrowthAttributes.ContentState {
        MetricGrowthAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MetricGrowthAttributes.ContentState {
         MetricGrowthAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MetricGrowthAttributes.preview) {
   MetricGrowthLiveActivity()
} contentStates: {
    MetricGrowthAttributes.ContentState.smiley
    MetricGrowthAttributes.ContentState.starEyes
}
