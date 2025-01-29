// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct TimeseriesOptions: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    startTimestamp: GraphQLNullable<Int> = nil,
    endTimestamp: GraphQLNullable<Int> = nil,
    interval: GraphQLNullable<GraphQLEnum<TimeseriesInterval>> = nil
  ) {
    __data = InputDict([
      "startTimestamp": startTimestamp,
      "endTimestamp": endTimestamp,
      "interval": interval
    ])
  }

  /// Unix timestamp (Inclusive)
  public var startTimestamp: GraphQLNullable<Int> {
    get { __data["startTimestamp"] }
    set { __data["startTimestamp"] = newValue }
  }

  /// Unix timestamp (Inclusive)
  public var endTimestamp: GraphQLNullable<Int> {
    get { __data["endTimestamp"] }
    set { __data["endTimestamp"] = newValue }
  }

  public var interval: GraphQLNullable<GraphQLEnum<TimeseriesInterval>> {
    get { __data["interval"] }
    set { __data["interval"] = newValue }
  }
}
