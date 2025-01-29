//
//  Chart.swift
//  BlueUI
//
//  Created by Oscar on 18/01/2025.
//

import SwiftUI
import Charts
import BlueAPI

@available(iOS 16.0.0, *)
public struct ChartSerie: Sendable {
    public var data: [FloatDataPoint]
    public var name: String
    public var color: Color
    
    public init(data: [FloatDataPoint], name: String, color: Color) {
        self.data = data
        self.name = name
        self.color = color
    }
}

@available(iOS 16.0.0, *)
public struct RootChart: View {
    public var serie: ChartSerie
    public var baseline: Double
    
    public var body: some View {
        Chart {
            let lowestY = calculateLowestY()
            
            ForEach(Array(serie.data.enumerated()), id: \.offset) { index, value in
                if let yValue = value.y, !yValue.isNaN {
                    ChartDataMarks(index: index, yValue: yValue, lowestY: lowestY, serieName: serie.name)
                }
            }
            
            RuleMark(y: .value("Baseline", baseline))
                .foregroundStyle(ColorPalette.brand)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 2]))
        }
        .chartXScale(domain: 0...24)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .chartOverlay { _ in
            Rectangle().fill(Color.clear)
        }
    }
    
    private func calculateLowestY() -> Double {
        serie.data.min(by: { $0.y ?? 0 < $1.y ?? 0 })?.y ?? 0
    }
}


@available(iOS 16.0.0, *)
public struct ChartDataMarks: ChartContent {
    public var index: Int
    public var yValue: Double
    public var lowestY: Double
    public var serieName: String
    
    public var body: some ChartContent {
        LineMark(
            x: .value("Index", index),
            y: .value("Variation (%)", yValue)
        )
        .foregroundStyle(ColorPalette.brand)
        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        
        AreaMark(
            x: .value("Index", index),
            yStart: .value("Baseline", lowestY),
            yEnd: .value(serieName, yValue)
        )
        .foregroundStyle(
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorPalette.brand.opacity(0.3),
                    ColorPalette.brand.opacity(0.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
