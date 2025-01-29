//
//  Analytics.swift
//  BlueAPI
//
//  Created by Oscar on 19/01/2025.
//

import Apollo
import BlueSDK
@preconcurrency import GeneratedBlueAPI


public struct FloatDataPoint: Sendable {
    public var x: Double!
    public var y: Double?
    
    public init(x: Double, y: Double?) {
        self.x = x
        self.y = y
    }
}

public struct ProcessedData {
    public let totalValue: Double
    public let valueChange: Double
    public let percentageChange: Double
    public let historicalState: [FloatDataPoint]
    
    public init(
        totalValue: Double,
        valueChange: Double,
        percentageChange: Double,
        historicalState: [FloatDataPoint]
    ) {
        self.totalValue = totalValue
        self.valueChange = valueChange
        self.percentageChange = percentageChange
        self.historicalState = historicalState
    }
}

public extension ProcessedData {
    static func createEmpty() -> ProcessedData {
        return ProcessedData(totalValue: 0, valueChange: 0, percentageChange: 0, historicalState: [])
    }
}

public enum MetricID: String, Sendable {
    case DEPOSITS = "totalDepositUsd"
    case BORROWED = "totalBorrowedUsd"
    case TVL = "tvlUsd"
}

@available(iOS 16.0.0, *)
public class Analaytics {
    private let client:ApolloClient
    
    init(client: ApolloClient) {
        self.client = client
    }
    
    public func getTVL(for chains: [ChainId], options:GraphQLNullable<TimeseriesOptions>) async throws -> ProcessedData {
        let result = try await self.fetchMetrics(metrics: [.TVL], chains: chains, options: options)
        return result[.TVL] ?? ProcessedData.createEmpty()
    }
    
    public func getDeposits(for chains: [ChainId],options:GraphQLNullable<TimeseriesOptions>) async throws -> ProcessedData {
        let result = try await self.fetchMetrics(metrics: [.DEPOSITS], chains: chains, options:options)
        return result[.DEPOSITS] ?? ProcessedData.createEmpty()
    }
    
    public func getBorrowed(for chains: [ChainId],options:GraphQLNullable<TimeseriesOptions>) async throws -> ProcessedData {
        let result = try await self.fetchMetrics(metrics: [.BORROWED], chains: chains, options: options)
        return result[.BORROWED] ?? ProcessedData.createEmpty()
    }
    
    public func fetchMetrics(
        metrics: [MetricID],
        chains: [ChainId],
        options: GraphQLNullable<TimeseriesOptions> = nil
    ) async throws -> [MetricID:ProcessedData] {
        let whereOptions = getQueryFilters(chains)
        let fetchDeposits = metrics.contains(.DEPOSITS)
        let fetchBorrowed = metrics.contains(.BORROWED)
        let fetchTVL = metrics.contains(.TVL)
        
        let res = try await self.client.fetchAsync(
            query: GetMorphoBluesQuery(
                options: options,
                where: whereOptions,
                fetchTotalDepositUsd: fetchDeposits,
                totalTotalBorrowUsd: fetchBorrowed,
                fetchTvlUsd: fetchTVL
            )
        )
        
        var results: [MetricID: ProcessedData] = [:]
        
        if fetchDeposits {
            results[.DEPOSITS] = processData(
                items: res.morphoBlues.items ?? [],
                valueExtractor: { $0.state?.totalDepositUsd },
                dataExtractor: { $0.historicalState?.totalDepositUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
            )
        }
        
        if fetchBorrowed {
            results[.BORROWED] = processData(
                items: res.morphoBlues.items ?? [],
                valueExtractor: { $0.state?.totalBorrowUsd },
                dataExtractor: { $0.historicalState?.totalBorrowUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
            )
        }
        
        if fetchTVL {
            results[.TVL] = processData(
                items: res.morphoBlues.items ?? [],
                valueExtractor: { $0.state?.tvlUsd },
                dataExtractor: { $0.historicalState?.tvlUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
            )
        }
        
        return results
    }
    
    private func processData<T>(
        items: [T],
        valueExtractor: (T) -> Double?,
        dataExtractor: (T) -> [FloatDataPoint]?
    ) -> ProcessedData {
        let totalValue = MathsHelper.calculateArraySum(
            items: items, valueExtractor: valueExtractor
        )
        
        let historicalState = aggregateDataPoint(
            items: items, dataExtractor: dataExtractor
        )
        
        let initialTotal = historicalState.first?.y ?? 0
        let currentTotal = historicalState.last?.y ?? 0
        
        let percentageChange = MathsHelper.calculateRatioChange(
            from: initialTotal, to: currentTotal
        )
        
        let valueChange = currentTotal - initialTotal
        
        return ProcessedData(
            totalValue: totalValue,
            valueChange: valueChange,
            percentageChange: percentageChange,
            historicalState: historicalState
        )
    }
    
    
    private func aggregateDataPoint<T>(
        items: [T],
        dataExtractor: (T) -> [FloatDataPoint]?
    ) -> [FloatDataPoint] {
        var aggregated: [Double: Double] = [:]
        
        for item in items {
            guard let dataPoints = dataExtractor(item) else { continue }
            
            for dataPoint in dataPoints {
                guard let x = dataPoint.x else { continue }
                let y = dataPoint.y ?? 0.0
                
                aggregated[x, default: 0.0] += y
            }
        }
        
        let sortedAggregated = aggregated.sorted { $0.key < $1.key }
        
        return sortedAggregated.map { FloatDataPoint(x: $0.key, y: $0.value) }
    }
    
    private func getValueExtractor(for metric: MetricID) -> (GetMorphoBluesQuery.Data.MorphoBlues.Item) -> Double? {
        switch metric {
        case .DEPOSITS: return { $0.state?.totalDepositUsd }
        case .BORROWED: return { $0.state?.totalBorrowUsd }
        case .TVL: return { $0.state?.tvlUsd }
        }
    }
    
    private func getDataExtractor(for metric: MetricID) -> (GetMorphoBluesQuery.Data.MorphoBlues.Item) -> [FloatDataPoint]? {
        switch metric {
        case .DEPOSITS: return { $0.historicalState?.totalDepositUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
        case .BORROWED: return { $0.historicalState?.totalBorrowUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
        case .TVL: return { $0.historicalState?.tvlUsd?.map { FloatDataPoint(x: $0.x, y: $0.y) } }
        }
    }
    
    private func getQueryFilters(_ chainIds: [ChainId]) -> GraphQLNullable<MorphoBlueFilters> {
        return GraphQLNullable(
            MorphoBlueFilters(
                idIn: nil,
                addressIn: nil,
                chainidIn: .some(chainIds.map { $0.rawValue })
            )
        )
    }
}
