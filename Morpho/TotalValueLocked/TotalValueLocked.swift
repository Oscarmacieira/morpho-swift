//
//  TotalValueLocked.swift
//  TotalValueLocked
//
//  Created by Oscar on 12/01/2025.
//

import WidgetKit
import SwiftUI
import BigNumber
import MorphoAPI
import AppIntents
import BlueSDK


let morphoApi = MorphoAPI.createClient();

struct ProcessedData {
    let totalValue: Double
    let valueChange: Double
    let percentageChange: Double
    let historicalState: [FloatDataPoint]
}

struct WidgetConfigIntent: WidgetConfigurationIntent {
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

struct WidgetEntry : TimelineEntry {
    let date: Date
    let total: Double
    let startTimestamp: Int
    let endTimestamp:Int
    let historicalState: [FloatDataPoint]
    let percentageChange:Double
    let valueChange: Double
    let configuration: WidgetConfigIntent
}

extension WidgetEntry {
        
    static func create(
        date: Date = Date(),
        total: Double = 0,
        startTimestamp: Int = TimeHelper.getDateStartOfDayTimestamp(),
        endTimestamp: Int = Time.now(60),
        historicalState: [FloatDataPoint] = [],
        percentageChange: Double = 0,
        valueChange: Double = 0,
        configuration: WidgetConfigIntent = WidgetConfigIntent()
    ) -> WidgetEntry {
        return WidgetEntry(
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
        startTimestamp: Int = Time.getDateStartOfDayTimestamp(),
        endTimestamp: Int = Time.now(60),
        historicalState: [FloatDataPoint] = [
            FloatDataPoint(x: 1, y: 10),
            FloatDataPoint(x: 2, y: 50),
            FloatDataPoint(x: 3, y: 30),
            FloatDataPoint(x: 4, y: 100)
        ],
        percentageChange: Double = 54.32,
        valueChange: Double = 1_234_567_890,
        configuration: WidgetConfigIntent = WidgetConfigIntent()
    ) -> WidgetEntry {
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
        formatters.percent.sign().digits(2).of(percentageChange) + "%"
    }
       
    var formattedValueChange: String {
        formatters.short.sign().(2).of(valueChange)
    }
       
    var formattedTotal: String {
        formatters.short.of(total)
    }
    
    var formattedMetricLabel: String {
        "\(configuration.metric?.label ?? DEFAULT_METRIC_INTENT.label)"
    }
    
    var formattedChainLabel: String {
        "\(configuration.chain?.label ?? DEFAULT_CHAIN_INTENT.label)"
    }
}
 

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry.create(
            configuration: WidgetConfigIntent()
        )
    }
    
    func snapshot(for configuration: WidgetConfigIntent, in context: Context) async -> WidgetEntry {
        WidgetEntry.createMock(
            date: Date(),
            configuration: configuration
        )
    }
    
    func timeline(for configuration: WidgetConfigIntent, in context: Context) async -> Timeline<WidgetEntry> {
        let currentDate = Date()
        let data:ProcessedData
        let metricIdentifier = configuration.metric?.identifier ?? MetricID.DEPOSITS
        let whereOptions = getQueryFilters(configuration.chain?.blockchainIds ?? [])
        
        do {
            let options = getTimeseriesOptions()
            switch (metricIdentifier) {
            
            case MetricID.DEPOSITS:
                let res = try await morphoApi.fe(
                        query: GetTotalDepositedQuery(
                            options: options,
                            where: whereOptions
                        )
                )
                data = processData(
                    items: res.data?.morphoBlues.items ?? [],
                    valueExtractor: { $0.state?.totalDepositUsd },
                    dataExtractor: { item in item.historicalState?.totalDepositUsd?.map { point in FloatDataPoint(x: point.x, y: point.y) } }
                )
            case MetricID.BORROWED:
                let res = try await morphoAPI.fetchAsync(
                    query: GetTotalBorrowedQuery(
                        options: options,
                        where: whereOptions
                    )
                )
                data = processData(
                    items: res.data?.morphoBlues.items ?? [],
                    valueExtractor: { $0.state?.totalBorrowUsd },
                    dataExtractor: { item in item.historicalState?.totalBorrowUsd?.map { point in FloatDataPoint(x: point.x, y: point.y) } }
                )
            case MetricID.TOTAL_VALUE_LOCKED:
                let res = try await morphoAPI.fetchAsync(
                    query: GetTotalValueLockedQuery(
                        options: options,
                        where: whereOptions
                    )
                )
                data = processData(
                    items: res.data?.morphoBlues.items ?? [],
                    valueExtractor: { $0.state?.tvlUsd },
                    dataExtractor: { item in item.historicalState?.tvlUsd?.map { point in FloatDataPoint(x: point.x, y: point.y) } }
                )
            }
            
            let entry = WidgetEntry.create(
                date: currentDate,
                total: data.totalValue,
                startTimestamp: options.startTimestamp?.unwrapped ?? 0,
                endTimestamp: options.endTimestamp?.unwrapped ?? 0,
                historicalState: data.historicalState,
                percentageChange: data.percentageChange,
                valueChange: data.valueChange,
                configuration: configuration
            )
            
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            print("Error fetching deposits: \(error)")
            return Timeline(entries: [WidgetEntry.create()], policy: .atEnd)
        }
    }
    
    private func getTimeseriesOptions() -> GraphQLNullable<TimeseriesOptions> {
        let now = GraphQLNullable<Int>(integerLiteral: Int(Time.now(60)))
        let startTimestamp = GraphQLNullable<Int>(integerLiteral: Time.getDateStartOfDayTimestamp())
        let interval = GraphQLNullable(TimeseriesInterval.hour)
        
        return GraphQLNullable(TimeseriesOptions(
            startTimestamp: startTimestamp,
            endTimestamp: now,
            interval: interval
        ))
    }
    
    private func getQueryFilters(_ chainids:[ChainId]) -> GraphQLNullable<MorphoBlueFilters> {
        return GraphQLNullable(
            MorphoBlueFilters(
                idIn: nil,
                addressIn: nil,
                chainidIn: .some(chainids.map { $0.rawValue })
            )
        )
    }
    
    private func processData<T>(
        items: [T],
        valueExtractor: (T) -> Double?,
        dataExtractor: (T) -> [FloatDataPoint]?
    ) -> ProcessedData {
        let totalValue = MathsHelper.calculateArraySum(
            items: items, valueExtractor: valueExtractor
        )
        
        let historicalState = Maths.aggregateDataPoint(
            items: items, dataExtractor: dataExtractor
        )
        
        let firstValue = historicalState.first?.y ?? 0;
        let lastValue = historicalState.last?.y ?? 0;
        
        let percentageChange = Maths.calculateRatioChange(
            from: firstValue, to: lastValue
        ) * 100
        
        let valueChange = lastValue - firstValue;
        
        return ProcessedData(
            totalValue: totalValue,
            valueChange: valueChange,
            percentageChange: percentageChange,
            historicalState: historicalState
        )
    }
    
}

struct TotalValueLockedEntryView : View {
    var entry: Provider.Entry

    
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
                        color: .textSecondary,
                        weight: .bold
                    )
                }
                Spacer()
                VStack(alignment:.trailing, spacing: 4) {
                    Typography(
                        text: entry.formattedPercentageChange,
                        variant: .caption,
                        color: .brand,
                        weight: .medium
                    )
                    Typography(
                        text: entry.formattedValueChange,
                        variant: .caption,
                        color: .brand,
                        weight: .medium
                    )
                 
                }
               
            }
                Spacer()
            PercentageGrowthChart(
                serie: ChartSerie(data: entry)
            )
                SimpleChartView(
                    deposits:entry.historicalState,
                    startTime: entry.startTimestamp
                )
                HStack {
                    Spacer()
                    HStack(spacing:0) {
                        Typography(
                            text: "$",
                            variant: .title,
                            color: .textSecondary
                        )
                        Typography(
                            text: entry.formattedTotal,
                            variant: .title,
                            color: .textBody
                        )
                    }
                                
                }
            
        }
    }
}

struct TotalValueLocked: Widget {
        let kind: String = "TotalValueLocked"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: WidgetConfigIntent.self,
            provider: Provider()) { entry in
            TotalValueLockedEntryView(entry: entry)
                .containerBackground(.backgroundBloc, for: .widget)
        }
            .configurationDisplayName("Morpho")
            .description("Get to see the Morpho Metrics in real time.")
    }
}

extension WidgetConfigIntent {
    fileprivate static var ETH_TOTAL_DEPOSITED: WidgetConfigIntent {
        let intent = WidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[0]
        intent.chain = ChainDetail.allChains[0]
        return intent
    }
    
    fileprivate static var BASE_TOTAL_BORROWED: WidgetConfigIntent {
        let intent = WidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[1]
        intent.chain = ChainDetail.allChains[1]
        return intent
    }
    
    fileprivate static var ALL_TVL: WidgetConfigIntent {
        let intent = WidgetConfigIntent()
        intent.metric = MetricDetail.allMetrics[2]
        intent.chain = ChainDetail.allChains[2]
        return intent
    }
}

#Preview(as: .systemSmall) {
    TotalValueLocked()
} timeline: {
    WidgetEntry.createMock(
        date: .now,
        configuration: .ETH_TOTAL_DEPOSITED
    )
    
    WidgetEntry.createMock(
        date: .now,
        configuration: .BASE_TOTAL_BORROWED
    )
    
    WidgetEntry.createMock(
        date: .now,
        configuration: .ALL_TVL
    )
}
