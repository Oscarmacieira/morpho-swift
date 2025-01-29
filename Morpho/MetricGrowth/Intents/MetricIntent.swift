//
//  MetricIntent.swift
//  Morpho
//
//  Created by Oscar on 18/01/2025.
//

import WidgetKit
import AppIntents
import BlueAPI

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
    MetricDetail(id: "tvl", label: "TVL", identifier: MetricID.TVL)
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
