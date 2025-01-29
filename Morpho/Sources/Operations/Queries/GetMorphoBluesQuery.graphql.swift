// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetMorphoBluesQuery: GraphQLQuery {
  public static let operationName: String = "GetMorphoBlues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetMorphoBlues { morphoBlues { __typename items { __typename state { __typename totalBorrowUsd totalCollateralUsd totalDepositUsd } } } }"#
    ))

  public init() {}

  public struct Data: MorphoAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MorphoAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("morphoBlues", MorphoBlues.self),
    ] }

    public var morphoBlues: MorphoBlues { __data["morphoBlues"] }

    /// MorphoBlues
    ///
    /// Parent Type: `PaginatedMorphoBlue`
    public struct MorphoBlues: MorphoAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MorphoAPI.Objects.PaginatedMorphoBlue }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("items", [Item]?.self),
      ] }

      public var items: [Item]? { __data["items"] }

      /// MorphoBlues.Item
      ///
      /// Parent Type: `MorphoBlue`
      public struct Item: MorphoAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MorphoAPI.Objects.MorphoBlue }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("state", State?.self),
        ] }

        /// Current state
        public var state: State? { __data["state"] }

        /// MorphoBlues.Item.State
        ///
        /// Parent Type: `MorphoBlueState`
        public struct State: MorphoAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MorphoAPI.Objects.MorphoBlueState }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("totalBorrowUsd", Double.self),
            .field("totalCollateralUsd", Double.self),
            .field("totalDepositUsd", Double.self),
          ] }

          /// Amount borrowed in all markets, in USD for display purpose
          public var totalBorrowUsd: Double { __data["totalBorrowUsd"] }
          /// Amount of collateral in all markets, in USD for display purpose
          public var totalCollateralUsd: Double { __data["totalCollateralUsd"] }
          /// Amount deposited in all markets, in USD for display purpose
          public var totalDepositUsd: Double { __data["totalDepositUsd"] }
        }
      }
    }
  }
}
