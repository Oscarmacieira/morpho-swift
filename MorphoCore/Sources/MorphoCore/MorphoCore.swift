// The Swift Programming Language
// https://docs.swift.org/swift-book
import GeneratedBlueAPI

public func getTimeseriesOptions(now: Int, startTimestamp:Int, interval:TimeseriesInterval) -> GraphQLNullable<TimeseriesOptions> {
            let now = GraphQLNullable<Int>(integerLiteral: now)
            let startTimestamp = GraphQLNullable<Int>(integerLiteral: startTimestamp)
            let interval = GraphQLNullable(interval)

            return GraphQLNullable(TimeseriesOptions(
                startTimestamp: startTimestamp,
                endTimestamp: now,
                interval: interval
            ))
}
