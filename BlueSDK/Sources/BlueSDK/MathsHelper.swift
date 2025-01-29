//
//  Maths.swift
//  Morpho
//
//  Created by Oscar on 16/01/2025.
//

public class MathsHelper {
    public static func calculateRatioChange(from: Double, to: Double) -> Double {
        if from == 0 {
            return 1
        }
        return (to - from) / from
    }
    
    
    public static func calculateArraySum<T>(
        items: [T],
        valueExtractor: (T) -> Double?
    ) -> Double {
        items.reduce(0) { accumulator, item in
            let value = valueExtractor(item) ?? 0
            return accumulator + value
        }
    }
}
