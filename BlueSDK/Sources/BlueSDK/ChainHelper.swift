//
//  Chains.swift
//  Morpho
//
//  Created by Oscar on 17/01/2025.
//

public struct Address: Sendable {
    let value: String

    init?(_ string: String) {
        guard string.hasPrefix("0x"), string.count > 2,
              string.dropFirst(2).allSatisfy({ $0.isHexDigit }) else {
            return nil
        }
        self.value = string
    }
}

public enum ChainId: Int, Sendable {
    case ETH_MAINNET = 1
    case BASE_MAINNET = 8453
}

public struct ChainCurrency:Sendable  {
    public var name: String
    public var symbol: String
    public var decimals: Int
}

public struct ChainMetadata: Sendable {
    public var id: ChainId
    public var name: String
    public var shortName: String
    public var identifier: String
    public var defaultRpcUrl: String
    public var explorerUrl: String
    public var logoSrc: String
    public var nativeCurrency: ChainCurrency
    public var isTestnet: Bool
}

public class ChainHelper {
    
    public static let BLUE_AVAILABLE_CHAINS: [ChainId] = [
        .ETH_MAINNET,
        .BASE_MAINNET
    ]
    
    public static let CHAIN_METADATA: [ChainId: ChainMetadata] = [
        .ETH_MAINNET: ChainMetadata(
            id: .ETH_MAINNET,
            name: "Ethereum",
            shortName: "ETH",
            identifier: "mainnet",
            defaultRpcUrl: "https://mainnet.infura.io/v3/84842078b09946638c03157f83405213",
            explorerUrl: "https://etherscan.io",
            logoSrc: "https://cdn.morpho.org/assets/chains/eth.svg",
            nativeCurrency: ChainCurrency(name: "Ether", symbol: "ETH", decimals: 18),
            isTestnet: false
        ),
        .BASE_MAINNET: ChainMetadata(
            id: .BASE_MAINNET,
            name: "Base",
            shortName: "Base",
            identifier: "base",
            defaultRpcUrl: "https://rpc.baseprotocol.org",
            explorerUrl: "https://basescan.org",
            logoSrc: "https://cdn.morpho.org/assets/chains/base.png",
            nativeCurrency: ChainCurrency(name: "Ether", symbol: "ETH", decimals: 18),
            isTestnet: false
        )
    ]
    
    public static func getMetadata(_ chainId: ChainId) -> ChainMetadata {
        return CHAIN_METADATA[chainId]!
    }
    
    public static func toHexChainId(chainId: Int) -> String {
        return String(format: "0x%x", chainId)
    }
    
    public static func getExplorerUrl(chainId: ChainId) -> String {
        return CHAIN_METADATA[chainId]!.explorerUrl
    }
    
    public static func getExplorerAddressUrl(chainId: ChainId, address: Address) -> String {
        let explorerUrl = getExplorerUrl(chainId: chainId);
        return "\(explorerUrl)/address/\(address)"
    }
    
    public static func getExplorerTransactionUrl(chainId: ChainId, tx: String) -> String {
        let explorerUrl = getExplorerUrl(chainId: chainId);
        return "\(explorerUrl)/tx/\(tx)"
    }
    

    public static func isSupported(chainId: Int) -> Bool {
        return BLUE_AVAILABLE_CHAINS.contains { $0.rawValue == chainId }
    }
}
