//
//  AaveHelper.swift
//  Morpho
//
//  Created by Oscar on 19/01/2025.
//

import Foundation

class AaveHelper {
    private let baseURL = "https://api.llama.fi"
    
    enum AaveHelperError: Error {
        case invalidURL
        case invalidResponse
    }
    
    struct AaveTVLResponse: Decodable {
        let totalTvl: TotalTvl
        struct TotalTvl: Decodable {
            let tvlInUsd: String
        }
    }


    /// Fetches the Total Value Locked (TVL) in USD.
    /// - Returns: A `Double` representing the TVL in USD.
    /// - Throws: An error if the request fails or the response is invalid.
    func getTVL() async throws -> Double {
        guard let url = URL(string: "\(baseURL)/tvl/aave") else {
            throw AaveHelperError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let tvlInUsd = try? JSONDecoder().decode(Double.self, from: data) else {
            throw AaveHelperError.invalidResponse
        }

        return tvlInUsd
    }
}
