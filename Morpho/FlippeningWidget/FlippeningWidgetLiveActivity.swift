//
//  FlippeningWidgetLiveActivity.swift
//  FlippeningWidget
//
//  Created by Oscar on 19/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlippeningWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlippeningWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlippeningWidgetAttributes.self) { context in
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

extension FlippeningWidgetAttributes {
    fileprivate static var preview: FlippeningWidgetAttributes {
        FlippeningWidgetAttributes(name: "World")
    }
}

extension FlippeningWidgetAttributes.ContentState {
    fileprivate static var smiley: FlippeningWidgetAttributes.ContentState {
        FlippeningWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlippeningWidgetAttributes.ContentState {
         FlippeningWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlippeningWidgetAttributes.preview) {
   FlippeningWidgetLiveActivity()
} contentStates: {
    FlippeningWidgetAttributes.ContentState.smiley
    FlippeningWidgetAttributes.ContentState.starEyes
}
