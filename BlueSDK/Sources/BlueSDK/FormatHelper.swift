//
//  FormatHelper.swift
//  Morpho
//
//  Created by Oscar on 12/01/2025.
//

import Foundation
import BigNumber

// Enum for Formatter Types
enum FormatType {
    case short
    case number
    case percent
}

// Base Formatter Options
public class FormatOptions {
    var digits: Int?
    var removeTrailingZeroFlag: Bool = false
    var signFlag: Bool = false
    var unit: String?
    var formatType: FormatType
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = digits ?? 2
        formatter.maximumFractionDigits = digits ?? 2
        return formatter
    }
    
    init(formatType: FormatType) {
        self.formatType = formatType
    }
    
    // Chaining Methods
    public func digits(_ value: Int) -> Self {
        self.digits = value
        return self
    }
    
    public func removeTrailingZero() -> Self {
        self.removeTrailingZeroFlag = true
        return self
    }
    
    public func sign() -> Self {
        self.signFlag = true
        return self
    }
    
    public func unit(_ value: String) -> Self {
        self.unit = value
        return self
    }
    
    func applyOptions(to value: String) -> String {
        var formatted = value
        
        if removeTrailingZeroFlag {
            formatted = formatted.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        }
        
        if let unit = unit {
            formatted += " \(unit)"
        }
        
        if signFlag {
            if !formatted.starts(with: "-") && !formatted.starts(with: "+") {
                formatted = "+" + formatted
            }
        }
        
        return formatted
    }
    
    func formatNumber(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = digits ?? 2
        numberFormatter.minimumFractionDigits = digits ?? 2

        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

public class BaseFormatter: FormatOptions {
    override init(formatType: FormatType) {
        super.init(formatType: formatType)
    }
    
    public func of(_ value: Double) -> String {
        let formatted = numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
        return applyOptions(to: formatted)
    }
    
    public func of(_ value: BInt, _ decimals: Int) -> String {
        let divisor = pow(10.0, Double(decimals))
        let doubleValue = Double(value) / divisor
        let formatted = formatNumber(doubleValue)
        return applyOptions(to: formatted)
    }
}

public class ShortFormatter: BaseFormatter {
    public override func of(_ value: Double) -> String {
        return formatShort(value)
    }
    
    public override func of(_ value: BInt, _ decimals: Int) -> String {
        let divisor = pow(10.0, Double(decimals))
        let doubleValue = Double(value) / divisor
        return formatShort(doubleValue)
    }
    
    private func formatShort(_ value: Double) -> String {
        let absValue = abs(value)
        let shortRanges: [(threshold: Double, suffix: String)] = [
            (1e24, "Y"), (1e21, "Z"), (1e18, "E"), (1e15, "P"),
            (1e12, "T"), (1e9, "B"), (1e6, "M"), (1e3, "k")
        ]
        
        for range in shortRanges where absValue >= range.threshold {
            let shortValue = absValue / range.threshold
            let formatted = formatNumber(shortValue) + range.suffix
            return applyOptions(to: (value < 0 ? "-" : "") + formatted)
        }
        
        return super.of(value)
    }
}

public class FormatHelper {
    public static var short: ShortFormatter { ShortFormatter(formatType: .short) }
    public static var number: BaseFormatter { BaseFormatter(formatType: .number) }
    public static var percent: BaseFormatter { BaseFormatter(formatType: .percent) }
}
