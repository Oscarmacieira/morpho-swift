//
//  MetricGrowthControl.swift
//  MetricGrowth
//
//  Created by Oscar on 18/01/2025.
//

import AppIntents
import SwiftUI
import WidgetKit

struct MetricGrowthControl: ControlWidget {
    static let kind: String = "com.oscarmac.Morpho-Analytics.MetricGrowth"
    
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: MetricGrowthWidgetProvider()
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
    }
}

extension MetricGrowthControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }
    
    struct MetricGrowthWidgetProvider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            MetricGrowthControl.Value(isRunning: false, name: configuration.timerName)
        }
        
        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return MetricGrowthControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

