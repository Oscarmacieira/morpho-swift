//
//  AppIntent.swift
//  TotalValueLocked
//
//  Created by Oscar on 12/01/2025.
//

import WidgetKit
import AppIntents


enum MetricID: String, AppEnum {
    case DEPOSITS = "deposits"
    case BORROWED = "borrowed"
    case TOTAL_VALUE_LOCKED = "totalValueLocked"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Metric Identifier"
    }

    static var caseDisplayRepresentations: [MetricID: DisplayRepresentation] {
        [
            .DEPOSITS: "Deposits",
            .BORROWED: "Borrowed",
            .TOTAL_VALUE_LOCKED: "TVL"
        ]
    }
}

struct MetricQuery: EntityQuery {
    func entities(for identifiers: [MetricDetail.ID]) async throws -> [MetricDetail] {
        MetricDetail.allMetrics.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [MetricDetail] {
        MetricDetail.allMetrics
    }
    
    func defaultResult() async -> MetricDetail? {
        try? await suggestedEntities().first
    }
}

var AVAILABLE_METRICS:[MetricDetail] = [
    MetricDetail(id: "deposits",  label: "Deposited", identifier: MetricID.DEPOSITS),
    MetricDetail(id: "borrowed",  label: "Borrowed", identifier: MetricID.BORROWED),
    MetricDetail(id: "tvl", label: "TVL", identifier: MetricID.TOTAL_VALUE_LOCKED)
]

struct MetricDetail: AppEntity {
    let id: String
    let label: String
    let identifier: MetricID

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Metric"
    static var defaultQuery = MetricQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(label)")
    }

    static let allMetrics: [MetricDetail] = AVAILABLE_METRICS
}

var DEFAULT_METRIC_INTENT = AVAILABLE_METRICS[0]
