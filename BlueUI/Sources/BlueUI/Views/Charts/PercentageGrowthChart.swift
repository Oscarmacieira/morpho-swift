//
//  PercentageGrowthChart.swift
//  BlueUI
//
//  Created by Oscar on 18/01/2025.
//

import SwiftUI
import BlueAPI
import BlueSDK

@available(iOS 16.0.0, *)
public struct PercentageGrowthChart: View {
    public var serie: ChartSerie
    
    let interval  = 3600
    let count = 24
    
    public init(serie: ChartSerie) {
        self.serie = serie
    }
    
    public var body: some View {
        RootChart(serie: transformedSerie(), baseline: 0)
    }
    
    public func transformedSerie() -> ChartSerie {
        let startY = serie.data.first?.y ?? Double(0)
        let filledData = fillMissingPoints(data: serie.data, count:count, interval:interval).map {
            
            let newY:Double? = $0.y == nil ? nil : MathsHelper.calculateRatioChange(from: startY, to: $0.y ?? 0)
            
            
            return FloatDataPoint(
                x: $0.x,
                y: newY)
        }
        return ChartSerie(data: filledData, name: serie.name, color: serie.color)
    }
    
    public func fillMissingPoints(data: [FloatDataPoint], count:Int, interval:Int) -> [FloatDataPoint] {
        var normalizedData: [FloatDataPoint] = []
        
        let startTime = Int(data.first?.x ?? 0);
        
        for i in 0..<count {
            let expectedTimestamp = Double(startTime) + (Double(i) * Double(interval))
            let point = data.first { $0.x == expectedTimestamp } ?? FloatDataPoint(x: expectedTimestamp, y: nil)
            normalizedData.append(point)
        }
        
        return normalizedData.sorted { $0.x < $1.x }
    }
    
    public func transformY(_ value: Double, startValue:Double) -> CGFloat {
        return MathsHelper.calculateRatioChange(from: startValue, to: value)
    }
}
