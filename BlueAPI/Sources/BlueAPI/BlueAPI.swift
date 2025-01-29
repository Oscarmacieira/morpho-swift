import Apollo
import ApolloAPI
import Foundation
import GeneratedBlueAPI

public let MORPHO_API_GRAPHQL_URL = URL(string: "https://blue-api.morpho.org/graphql")!

@available(iOS 16.0.0, *)
public class MorphoAPI {
    public let client: ApolloClient
    public let analytics: Analaytics
    
    public init() {
        self.client = ApolloClient(url: MORPHO_API_GRAPHQL_URL);
        self.analytics = Analaytics(client: self.client)
    }
}

enum ApolloError: Error {
    case graphQL([GraphQLError])
    case invalidResponse
}

@available(iOS 16.0.0, *)
public extension ApolloClient {
    func fetchAsync<Query: GraphQLQuery>(
        query: Query
    ) async throws -> Query.Data where Query.Data: RootSelectionSet & Sendable {
        try await withCheckedThrowingContinuation { continuation in
            self.fetch(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else if let errors = graphQLResult.errors {
                        continuation.resume(throwing: ApolloError.graphQL(errors))
                    } else {
                        continuation.resume(throwing: ApolloError.invalidResponse)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
