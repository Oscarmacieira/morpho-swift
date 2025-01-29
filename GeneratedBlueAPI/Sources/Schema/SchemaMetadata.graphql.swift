// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GeneratedBlueAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GeneratedBlueAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GeneratedBlueAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GeneratedBlueAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "FloatDataPoint": return GeneratedBlueAPI.Objects.FloatDataPoint
    case "MorphoBlue": return GeneratedBlueAPI.Objects.MorphoBlue
    case "MorphoBlueState": return GeneratedBlueAPI.Objects.MorphoBlueState
    case "MorphoBlueStateHistory": return GeneratedBlueAPI.Objects.MorphoBlueStateHistory
    case "PaginatedMorphoBlue": return GeneratedBlueAPI.Objects.PaginatedMorphoBlue
    case "Query": return GeneratedBlueAPI.Objects.Query
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
