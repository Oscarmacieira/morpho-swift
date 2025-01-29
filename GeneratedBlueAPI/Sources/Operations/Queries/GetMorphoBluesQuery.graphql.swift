// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetMorphoBluesQuery: GraphQLQuery {
  public static let operationName: String = "getMorphoBlues"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getMorphoBlues($options: TimeseriesOptions, $where: MorphoBlueFilters, $fetchTotalDepositUsd: Boolean!, $totalTotalBorrowUsd: Boolean!, $fetchTvlUsd: Boolean!) { morphoBlues(where: $where) { __typename items { __typename state { __typename totalDepositUsd totalBorrowUsd tvlUsd } historicalState { __typename totalDepositUsd(options: $options) @include(if: $fetchTotalDepositUsd) { __typename x y } totalBorrowUsd(options: $options) @include(if: $totalTotalBorrowUsd) { __typename x y } tvlUsd(options: $options) @include(if: $fetchTvlUsd) { __typename x y } } } } }"#
    ))

  public var options: GraphQLNullable<TimeseriesOptions>
  public var `where`: GraphQLNullable<MorphoBlueFilters>
  public var fetchTotalDepositUsd: Bool
  public var totalTotalBorrowUsd: Bool
  public var fetchTvlUsd: Bool

  public init(
    options: GraphQLNullable<TimeseriesOptions>,
    `where`: GraphQLNullable<MorphoBlueFilters>,
    fetchTotalDepositUsd: Bool,
    totalTotalBorrowUsd: Bool,
    fetchTvlUsd: Bool
  ) {
    self.options = options
    self.`where` = `where`
    self.fetchTotalDepositUsd = fetchTotalDepositUsd
    self.totalTotalBorrowUsd = totalTotalBorrowUsd
    self.fetchTvlUsd = fetchTvlUsd
  }

  public var __variables: Variables? { [
    "options": options,
    "where": `where`,
    "fetchTotalDepositUsd": fetchTotalDepositUsd,
    "totalTotalBorrowUsd": totalTotalBorrowUsd,
    "fetchTvlUsd": fetchTvlUsd
  ] }

  public struct Data: GeneratedBlueAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("morphoBlues", MorphoBlues.self, arguments: ["where": .variable("where")]),
    ] }

    public var morphoBlues: MorphoBlues { __data["morphoBlues"] }

    /// MorphoBlues
    ///
    /// Parent Type: `PaginatedMorphoBlue`
    public struct MorphoBlues: GeneratedBlueAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.PaginatedMorphoBlue }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("items", [Item]?.self),
      ] }

      public var items: [Item]? { __data["items"] }

      /// MorphoBlues.Item
      ///
      /// Parent Type: `MorphoBlue`
      public struct Item: GeneratedBlueAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.MorphoBlue }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("state", State?.self),
          .field("historicalState", HistoricalState?.self),
        ] }

        /// Current state
        public var state: State? { __data["state"] }
        /// State history
        public var historicalState: HistoricalState? { __data["historicalState"] }

        /// MorphoBlues.Item.State
        ///
        /// Parent Type: `MorphoBlueState`
        public struct State: GeneratedBlueAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.MorphoBlueState }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("totalDepositUsd", Double.self),
            .field("totalBorrowUsd", Double.self),
            .field("tvlUsd", Double.self),
          ] }

          /// Amount deposited in all markets, in USD for display purpose
          public var totalDepositUsd: Double { __data["totalDepositUsd"] }
          /// Amount borrowed in all markets, in USD for display purpose
          public var totalBorrowUsd: Double { __data["totalBorrowUsd"] }
          /// TVL (collateral + supply - borrows), in USD for display purpose
          public var tvlUsd: Double { __data["tvlUsd"] }
        }

        /// MorphoBlues.Item.HistoricalState
        ///
        /// Parent Type: `MorphoBlueStateHistory`
        public struct HistoricalState: GeneratedBlueAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.MorphoBlueStateHistory }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .include(if: "fetchTotalDepositUsd", .field("totalDepositUsd", [TotalDepositUsd]?.self, arguments: ["options": .variable("options")])),
            .include(if: "totalTotalBorrowUsd", .field("totalBorrowUsd", [TotalBorrowUsd]?.self, arguments: ["options": .variable("options")])),
            .include(if: "fetchTvlUsd", .field("tvlUsd", [TvlUsd]?.self, arguments: ["options": .variable("options")])),
          ] }

          /// Amount deposited in all markets, in USD for display purpose
          public var totalDepositUsd: [TotalDepositUsd]? { __data["totalDepositUsd"] }
          /// Amount borrowed in all markets, in USD for display purpose
          public var totalBorrowUsd: [TotalBorrowUsd]? { __data["totalBorrowUsd"] }
          /// TVL (collateral + supply - borrows), in USD for display purpose
          public var tvlUsd: [TvlUsd]? { __data["tvlUsd"] }

          /// MorphoBlues.Item.HistoricalState.TotalDepositUsd
          ///
          /// Parent Type: `FloatDataPoint`
          public struct TotalDepositUsd: GeneratedBlueAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.FloatDataPoint }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("x", Double.self),
              .field("y", Double?.self),
            ] }

            public var x: Double { __data["x"] }
            public var y: Double? { __data["y"] }
          }

          /// MorphoBlues.Item.HistoricalState.TotalBorrowUsd
          ///
          /// Parent Type: `FloatDataPoint`
          public struct TotalBorrowUsd: GeneratedBlueAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.FloatDataPoint }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("x", Double.self),
              .field("y", Double?.self),
            ] }

            public var x: Double { __data["x"] }
            public var y: Double? { __data["y"] }
          }

          /// MorphoBlues.Item.HistoricalState.TvlUsd
          ///
          /// Parent Type: `FloatDataPoint`
          public struct TvlUsd: GeneratedBlueAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { GeneratedBlueAPI.Objects.FloatDataPoint }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("x", Double.self),
              .field("y", Double?.self),
            ] }

            public var x: Double { __data["x"] }
            public var y: Double? { __data["y"] }
          }
        }
      }
    }
  }
}
