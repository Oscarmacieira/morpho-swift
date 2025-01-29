//
//  FlippeningLiveActivity.swift
//  Morpho
//
//  Created by Oscar on 19/01/2025.
//


import ActivityKit
import WidgetKit
import SwiftUI

struct FlippeningAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlippeningLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlippeningAttributes.self) { context in
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

extension FlippeningAttributes {
    fileprivate static var preview: FlippeningAttributes {
        FlippeningAttributes(name: "World")
    }
}

extension FlippeningAttributes.ContentState {
    fileprivate static var smiley: FlippeningAttributes.ContentState {
        FlippeningAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlippeningAttributes.ContentState {
         FlippeningAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlippeningAttributes.preview) {
    FlippeningLiveActivity()
} contentStates: {
    FlippeningAttributes.ContentState.smiley
    FlippeningAttributes.ContentState.starEyes
}
