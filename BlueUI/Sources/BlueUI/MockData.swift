//
//  MockData.swift
//  BlueUI
//
//  Created by Oscar on 18/01/2025.
//

import SwiftUI
import BlueAPI

@available(iOS 16.0.0, *)
public class MOCK_DATA {
   public static let FLOAT_DATA_POINTS_ARRAY = [
        FloatDataPoint(x: 1, y: 10),
        FloatDataPoint(x: 2, y: 50),
        FloatDataPoint(x: 3, y: 30),
        FloatDataPoint(x: 4, y: 100)
    ]
    
    public static let CHART_SERIE = ChartSerie(data: FLOAT_DATA_POINTS_ARRAY, name: "Mock Serie", color: Color(.brand))
}

