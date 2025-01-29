// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Filtering options for morpho blue deployments.
public struct MorphoBlueFilters: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    idIn: GraphQLNullable<[String]> = nil,
    addressIn: GraphQLNullable<[String]> = nil,
    chainidIn: GraphQLNullable<[Int]> = nil
  ) {
    __data = InputDict([
      "id_in": idIn,
      "address_in": addressIn,
      "chainId_in": chainidIn
    ])
  }

  /// Filter by morpho blue id
  public var idIn: GraphQLNullable<[String]> {
    get { __data["id_in"] }
    set { __data["id_in"] = newValue }
  }

  /// Filter by deployment address. Case insensitive.
  public var addressIn: GraphQLNullable<[String]> {
    get { __data["address_in"] }
    set { __data["address_in"] = newValue }
  }

  /// Filter by chain id
  public var chainidIn: GraphQLNullable<[Int]> {
    get { __data["chainId_in"] }
    set { __data["chainId_in"] = newValue }
  }
}
