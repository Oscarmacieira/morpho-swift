//
//  MetricGrowthBundle.swift
//  MetricGrowth
//
//  Created by Oscar on 18/01/2025.
//

import WidgetKit
import SwiftUI

@main
struct MorphoWidgetsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MetricGrowthWidgetBundle().body
        FlippeningWidgetBundle().body
    }
}

struct MetricGrowthWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MetricGrowthWidget()
        MetricGrowthControl()
        MetricGrowthLiveActivity()
    }
}

struct FlippeningWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        FlippeningWidget()
        FlippeningControl()
        FlippeningLiveActivity()
    }
}
