//
//  FlippeningWidget.swift
//  Morpho
//
//  Created by Oscar on 19/01/2025.
//

import WidgetKit
import AppIntents
import SwiftUI
import BlueUI
import BlueAPI
import BlueSDK
import MorphoCore
import GeneratedBlueAPI

struct FlippeningWidgetConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Nothing to see here" }
    static var description: IntentDescription { "Nothig to see here."
    }
    
    init() {}
}

struct FlippeningWidgetEntry: TimelineEntry {
    let date: Date
    let aaveTVL: Double
    let morphoTVL: Double
    let flippeningRatio:Double
}

extension FlippeningWidgetEntry {
    static func create(
        date: Date = Date(),
        aaveTVL: Double = 0,
        morphoTVL: Double = 0,
        flippeningRatio:Double = 0
    ) -> FlippeningWidgetEntry {
        .init(
            date: date,
            aaveTVL: aaveTVL,
            morphoTVL: morphoTVL,
            flippeningRatio: flippeningRatio
        )
    }
    
    static func createMock(
        date: Date = Date(),
        aaveTVL: Double = 10_000_000_000_000,
        morphoTVL: Double = 5_000_000_000_000,
        flippeningRatio:Double = 0.5
    ) -> FlippeningWidgetEntry {
        .create(
            date: date,
            aaveTVL: aaveTVL,
            morphoTVL: morphoTVL,
            flippeningRatio: flippeningRatio
        )
    }
}

struct FlippeningWidgetProvider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> FlippeningWidgetEntry {
        FlippeningWidgetEntry.create(
            date: Date()
        )
    }
    
    func snapshot(for configuration: FlippeningWidgetConfigIntent, in context: Context) async -> FlippeningWidgetEntry {
        FlippeningWidgetEntry.create(date: Date())
    }
    
    func timeline(for configuration: FlippeningWidgetConfigIntent, in context: Context) async -> Timeline<FlippeningWidgetEntry> {
        let currentDate = Date()
        
        do {
            let morphoData = try await morphoAPI.analytics.getTVL(for: [.BASE_MAINNET, .ETH_MAINNET], options:getTimeseriesOptions(now: TimeHelper.now(60), startTimestamp: TimeHelper.getDateStartOfDayTimestamp(), interval: TimeseriesInterval.hour))
            let morphoTVL = morphoData.totalValue
            
            let aaveTVL = try await aaveHelper.getTVL()
            
            let flippeningRatio = morphoTVL / aaveTVL
            
            let entry = FlippeningWidgetEntry.create(
                date: currentDate,
                aaveTVL: aaveTVL,
                morphoTVL: morphoData.totalValue,
                flippeningRatio: flippeningRatio
            )
            
            return Timeline(entries: [entry], policy: .atEnd)
            
        } catch {
            print("Error fetching data: \(error)")
            return Timeline(entries: [FlippeningWidgetEntry.create()], policy: .atEnd)
        }
    }
}

struct TVLValueView: View {
    var tvl: Double
    var icon: String
    var symbol: String
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                IconImage(name: icon, size: 12)
                Typography(
                    text: symbol,
                    
                    variant: .body,
                    color: ColorPalette.textSecondary,
                    weight: .medium
                )
            }
            Spacer()
            Typography(
                text: "$"+FormatHelper.short.of(tvl),
                variant: .body,
                weight: .medium
            )
        }
    }
}

struct FlippeningIndicatorView: View {
    var entry: FlippeningWidgetProvider.Entry
    var body: some View {
        VStack {
            HStack {
                Typography(
                    text: FormatHelper.percent.digits(2).removeTrailingZero().of(entry.flippeningRatio * 100)+"%",
                    variant: .caption,
                    color: ColorPalette.brand
                )
                Spacer()
                Typography(
                    text: "$"+FormatHelper.short.digits(2).of(entry.aaveTVL - entry.morphoTVL),
                    variant: .caption,
                    color: ColorPalette.brand
                )
            }
            ProgressBar(
                percentage: entry.flippeningRatio,
                fillColor: ColorPalette.brand,
                backgroundColor: ColorPalette.backgroundBlock,
                height: 10)
        }
    }
}

struct FlippeningWidgetEntryView : View {
    var entry: FlippeningWidgetProvider.Entry
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Typography(
                text: "Total Value Locked",
                variant: .body,
                weight: .bold
            )
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                TVLValueView(tvl: entry.morphoTVL, icon: "MORPHO", symbol: "Morpho")
                TVLValueView(tvl: entry.aaveTVL, icon: "AAVE", symbol: "Aave")
            }
            Spacer()
            FlippeningIndicatorView(entry: entry)
        }
    }
}

struct FlippeningWidget: Widget {
    let kind: String = "FlippeningWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: FlippeningWidgetConfigIntent.self,
            provider: FlippeningWidgetProvider()
        ) { entry in
            FlippeningWidgetEntryView(entry: entry)
                .containerBackground(ColorPalette.backgroundBase, for: .widget)
        }
        .configurationDisplayName("Morpho / Aave Flippening")
        .description("Displays flippening metrics in real time.")
        .supportedFamilies([.systemSmall])
    }
}


#Preview(as: .systemSmall) {
    FlippeningWidget()
} timeline: {
    FlippeningWidgetEntry.createMock()
    FlippeningWidgetEntry.createMock(
        flippeningRatio: 1.2
    )
}
