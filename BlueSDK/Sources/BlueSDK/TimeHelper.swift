//
//  TimeHelper.swift
//  Morpho
//
//  Created by Oscar on 12/01/2025.
//

import Foundation
import BigNumber

public enum TimeUnit: String, CaseIterable {
    case ms, s, min, h, d, w, mo, y
}

public struct TimePeriod {
    public let unit: TimeUnit
    public let duration: BInt
}


public class TimeHelper {
    public static func timestamp() -> BInt {
        return BInt(ceil(Date().timeIntervalSince1970))
    }

    public static func now(_ lag: Int) -> Int {
        let time = timestamp()
        let roundedMinutes = time / BInt(60)
        return Int(roundedMinutes * BInt(lag))
    }

    public static func getDateStartOfDayTimestamp() -> Int {
        return Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
    }
}

