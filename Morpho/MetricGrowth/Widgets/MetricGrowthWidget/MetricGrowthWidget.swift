//
//  MetricGrowth.swift
//  MetricGrowth
//
//  Created by Oscar on 18/01/2025.
//

import WidgetKit
import SwiftUI
import AppIntents
import BlueAPI
import BlueUI
import BlueSDK
import GeneratedBlueAPI
import MorphoCore

struct MetricGrowthWidgetConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select Metric" }
    static var description: IntentDescription { "Selects the metric to display."
    }
    
    @Parameter(title: "Metric", default: DEFAULT_METRIC_INTENT)
    var metric: MetricDetail?
    
    @Parameter(title: "Chain", default: DEFAULT_CHAIN_INTENT)
    var chain: ChainDetail?
    
    init(metric: ChainDetail? = nil) {
        
    }
    
    init(metric: MetricDetail? = nil, chain: ChainDetail? = nil) {
        self.metric = metric ?? DEFAULT_METRIC_INTENT
        self.chain = chain ?? DEFAULT_CHAIN_INTENT
    }
    
    init() {}
}

extension MetricGrowthWidgetConfigIntent {
    fileprivate static var ETH_TOTAL_DEPOSITED: MetricGrowthWidgetConfigIntent {
        let intent = MetricGrowthWidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[0]
        intent.chain = ChainDetail.allChains[0]
        return intent
    }
    
    fileprivate static var BASE_TOTAL_BORROWED: MetricGrowthWidgetConfigIntent {
        let intent = MetricGrowthWidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[1]
        intent.chain = ChainDetail.allChains[1]
        return intent
    }
    
    fileprivate static var ALL_TVL: MetricGrowthWidgetConfigIntent {
        let intent = MetricGrowthWidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[2]
        intent.chain = ChainDetail.allChains[2]
        return intent
    }
}

struct MetricGrowthWidgetEntry : TimelineEntry {
    let date: Date
    let total: Double
    let startTimestamp: Int
    let endTimestamp:Int
    let historicalState: [FloatDataPoint]
    let percentageChange:Double
    let valueChange: Double
    let configuration: MetricGrowthWidgetConfigIntent
}

extension MetricGrowthWidgetEntry {
    static func create(
        date: Date = Date(),
        total: Double = 0,
        startTimestamp: Int = TimeHelper.getDateStartOfDayTimestamp(),
        endTimestamp: Int = TimeHelper.now(60),
        historicalState: [FloatDataPoint] = [],
        percentageChange: Double = 0,
        valueChange: Double = 0,
        configuration: MetricGrowthWidgetConfigIntent = MetricGrowthWidgetConfigIntent()
    ) -> MetricGrowthWidgetEntry {
        return MetricGrowthWidgetEntry(
            date: date,
            total: total,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            historicalState: historicalState,
            percentageChange: percentageChange,
            valueChange: valueChange,
            configuration: configuration
        )
    }
    
    
    static func createMock(
        date: Date = Date(),
        total: Double = 6_000_000_000_000,
        startTimestamp: Int = TimeHelper.getDateStartOfDayTimestamp(),
        endTimestamp: Int = TimeHelper.now(60),
        historicalState: [FloatDataPoint] = MOCK_DATA.FLOAT_DATA_POINTS_ARRAY,
        percentageChange: Double = 54.32,
        valueChange: Double = 1_234_567_890,
        configuration: MetricGrowthWidgetConfigIntent = MetricGrowthWidgetConfigIntent()
    ) -> MetricGrowthWidgetEntry {
        return create(
            date: date,
            total: total,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            historicalState: historicalState,
            percentageChange: percentageChange,
            valueChange: valueChange,
            configuration: configuration
        )
    }
    
    var formattedPercentageChange: String {
        FormatHelper.percent.sign().digits(2).of(percentageChange * 100) + "%"
    }
    
    var formattedValueChange: String {
        FormatHelper.short.sign().digits(2).of(valueChange)
    }
    
    var formattedTotal: String {
        FormatHelper.short.of(total)
    }
    
    var formattedMetricLabel: String {
        "\(configuration.metric?.label ?? DEFAULT_METRIC_INTENT.label)"
    }
    
    var formattedChainLabel: String {
        "\(configuration.chain?.label ?? DEFAULT_CHAIN_INTENT.label)"
    }
}

struct MetricGrowthWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MetricGrowthWidgetEntry {
        MetricGrowthWidgetEntry.create(
            configuration: MetricGrowthWidgetConfigIntent()
        )
    }
    
    func snapshot(for configuration: MetricGrowthWidgetConfigIntent, in context: Context) async -> MetricGrowthWidgetEntry {
        MetricGrowthWidgetEntry.createMock(
            date: Date(),
            configuration: configuration
        )
    }
    
    func timeline(for configuration: MetricGrowthWidgetConfigIntent, in context: Context) async -> Timeline<MetricGrowthWidgetEntry> {
        let currentDate = Date()
        
        let metricIdentifier = configuration.metric?.identifier ?? MetricID.DEPOSITS
        let chainIdentifiers = configuration.chain?.blockchainIds ?? []
        
        do {
            let options = getTimeseriesOptions(
                now: TimeHelper.now(60),
                startTimestamp: TimeHelper.getDateStartOfDayTimestamp(),
                interval: TimeseriesInterval.hour
            )
            
            let data = try await morphoAPI.analytics.fetchMetrics(
                metrics: [metricIdentifier],
                chains: chainIdentifiers,
                options: options
            )[metricIdentifier];
            
            
            let entry = MetricGrowthWidgetEntry.create(
                date: currentDate,
                total: data?.totalValue ?? 0,
                startTimestamp: options.startTimestamp?.unwrapped ?? 0,
                endTimestamp: options.endTimestamp?.unwrapped ?? 0,
                historicalState: data?.historicalState ?? [],
                percentageChange: data?.percentageChange ?? 0,
                valueChange: data?.valueChange ?? 0,
                configuration: configuration
            )
            
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            print("Error fetching deposits: \(error)")
            return Timeline(entries: [MetricGrowthWidgetEntry.create()], policy: .atEnd)
        }
    }
}


struct MetricGrowthEntryView : View {
    var entry: MetricGrowthWidgetProvider.Entry
    
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 5) {
                        Image("Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 12,
                                height: 12
                            )
                        Typography(
                            text: entry.formattedMetricLabel,
                            variant: .body,
                            weight: .bold
                        )
                    }
                    Typography(
                        text: entry.formattedChainLabel,
                        variant: .caption,
                        color: ColorPalette.textBody,
                        weight: .bold
                    )
                }
                Spacer()
                VStack(alignment:.trailing, spacing: 4) {
                    Typography(
                        text: entry.formattedPercentageChange,
                        variant: .caption,
                        color: ColorPalette.brand,
                        weight: .medium
                    )
                    Typography(
                        text: entry.formattedValueChange,
                        variant: .caption,
                        color: ColorPalette.brand,
                        weight: .medium
                    )
                    
                }
                
            }
            Spacer()
            PercentageGrowthChart(
                serie: ChartSerie(data: entry.historicalState, name: "", color: ColorPalette.brand)
            )
            HStack {
                Spacer()
                HStack(spacing:0) {
                    Typography(
                        text: "$",
                        variant: .title,
                        color: ColorPalette.textSecondary
                    )
                    Typography(
                        text: entry.formattedTotal,
                        variant: .title,
                        color: ColorPalette.textBody
                    )
                }
                
            }
            
        }
    }
}

struct MetricGrowthWidget: Widget {
    let kind: String = "TotalValueLocked"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MetricGrowthWidgetConfigIntent.self,
            provider: MetricGrowthWidgetProvider()) { entry in
                MetricGrowthEntryView(entry: entry)
                    .containerBackground(ColorPalette.backgroundBase, for: .widget)
            }
            .configurationDisplayName("Morpho")
            .description("Get to see the Morpho Metrics in real time.")
            .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}

#Preview(as: .systemSmall) {
    MetricGrowthWidget()
} timeline: {
    MetricGrowthWidgetEntry.createMock(
        date: .now,
        configuration: .ETH_TOTAL_DEPOSITED
    )
    
    MetricGrowthWidgetEntry.createMock(
        date: .now,
        configuration: .BASE_TOTAL_BORROWED
    )
    
    MetricGrowthWidgetEntry.createMock(
        date: .now,
        configuration: .ALL_TVL
    )
}


