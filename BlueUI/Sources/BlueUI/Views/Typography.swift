//
//  Typography.swift
//  Morpho
//
//  Created by Oscar on 17/01/2025.
//

import SwiftUI

public enum TypographyVariant {
    case title
    case subtitle
    case body
    case caption
}

@available(iOS 16.0.0, *)
public struct Typography: View {
    let text: String
    let variant: TypographyVariant
    let color: Color?
    let weight: Font.Weight?

    public init(text: String, variant: TypographyVariant, color: Color? = nil, weight: Font.Weight? = nil) {
        self.text = text
        self.variant = variant
        self.color = color ?? ColorPalette.textBody
        self.weight = weight
    }

    public var body: some View {
        Text(text)
            .font(font(for: variant))
            .foregroundColor(color)
            .fontWeight(weight ?? defaultWeight(for: variant))
    }

    private func font(for variant: TypographyVariant) -> Font {
        switch variant {
        case .title:
            return .system(size: 22)
        case .subtitle:
            return .system(size: 14)
        case .body:
            return .system(size: 11)
        case .caption:
            return .system(size: 9)
        }
    }

    private func defaultWeight(for variant: TypographyVariant) -> Font.Weight {
        switch variant {
            case .title: return .bold
            case .subtitle: return .bold
            case .body: return .regular
            case .caption: return .regular
        }
    }
}
