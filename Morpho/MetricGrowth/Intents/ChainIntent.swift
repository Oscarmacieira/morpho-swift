//
//  ChainIntent.swift
//  Morpho
//
//  Created by Oscar on 17/01/2025.
//

import WidgetKit
import BlueSDK
import AppIntents

struct ChainQuery: EntityQuery {
    func entities(for identifiers: [ChainDetail.ID]) async throws -> [ChainDetail] {
        ChainDetail.allChains.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [ChainDetail] {
        ChainDetail.allChains
    }
    
    func defaultResult() async -> ChainDetail? {
        try? await suggestedEntities().first
    }
}

var AVAILABLE_CHAINS:[ChainDetail] = [
    ChainDetail(id: ChainHelper.getMetadata(.ETH_MAINNET).identifier, blockchainIds: [.ETH_MAINNET], label: "Mainnet"),
    ChainDetail(id: ChainHelper.getMetadata(.BASE_MAINNET).identifier, blockchainIds: [.BASE_MAINNET], label: "Base"),
    ChainDetail(id: "all", blockchainIds: [.ETH_MAINNET, .BASE_MAINNET], label: "All Networks")
]

struct ChainDetail: AppEntity {
    let id: String
    let blockchainIds: [ChainId]
    let label: String
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Chain"
    static var defaultQuery = ChainQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(label)")
    }

    static let allChains: [ChainDetail] = AVAILABLE_CHAINS
}

var DEFAULT_CHAIN_INTENT = AVAILABLE_CHAINS[0]
