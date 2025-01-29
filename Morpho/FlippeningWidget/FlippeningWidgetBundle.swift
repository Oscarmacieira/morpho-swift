//
//  FlippeningWidgetBundle.swift
//  FlippeningWidget
//
//  Created by Oscar on 19/01/2025.
//

import WidgetKit
import SwiftUI

@main
struct FlippeningWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlippeningWidget()
        FlippeningWidgetControl()
        FlippeningWidgetLiveActivity()
    }
}
