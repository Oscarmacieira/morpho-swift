//
//  TotalValueLockedLiveActivity.swift
//  TotalValueLocked
//
//  Created by Oscar on 12/01/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TotalValueLockedAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TotalValueLockedLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TotalValueLockedAttributes.self) { context in
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

extension TotalValueLockedAttributes {
    fileprivate static var preview: TotalValueLockedAttributes {
        TotalValueLockedAttributes(name: "World")
    }
}

extension TotalValueLockedAttributes.ContentState {
    fileprivate static var smiley: TotalValueLockedAttributes.ContentState {
        TotalValueLockedAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TotalValueLockedAttributes.ContentState {
         TotalValueLockedAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TotalValueLockedAttributes.preview) {
   TotalValueLockedLiveActivity()
} contentStates: {
    TotalValueLockedAttributes.ContentState.smiley
    TotalValueLockedAttributes.ContentState.starEyes
}
