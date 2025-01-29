//
//  Theme.swift
//  BlueUI
//
//  Created by Oscar on 19/01/2025.
//
import SwiftUI

@available(iOS 16.0.0, *)
public struct ColorPalette {
    // MARK: - Constant Colors
    public static let pearl = Color(hex: "#fafafa")
    public static let white = Color(hex: "#ffffff")
    public static let grey = Color(hex: "#33363A")
    public static let dark = Color(hex: "#222529")
    public static let black = Color(hex: "#000000")
    public static let vanta = Color(hex: "#15181A")

    // MARK: - Brand Colors
    public static let brand = Color(hex: "#2973FF")
    public static let active = Color(hex: "#5792FF")
    public static let error = Color(hex: "#FF7792")
    public static let yellow = Color(hex: "#FFB13D")
    public static let valid = Color(hex: "#39a699")

    // MARK: - Gradients
    public static let gradientEarth = Color(hex: "#39a699")
    // Add other gradient colors here

    // MARK: - Text Colors
    public static let textPrimary = Color(hex: "#fafafa", alpha: 1.0)
    public static let textBody = Color(hex: "#fafafa", alpha: 0.95)
    public static let textSecondary = Color(hex: "#fafafa", alpha: 0.7)
    public static let textTertiary = Color(hex: "#fafafa", alpha: 0.5)
    public static let textBrand = Color(hex: "#2973FF", alpha: 0.95)

    // MARK: - Interactive Colors
    public static let interactiveDisabled = Color(hex: "#fafafa", alpha: 0.3)
    public static let interactiveActive = Color(hex: "#5792FF", alpha: 0.95)
    public static let interactiveError = Color(hex: "#FF7792", alpha: 0.95)
    public static let interactiveValid = Color(hex: "#39a699", alpha: 0.95)
    public static let interactiveSoftWarning = Color(hex: "#FFB13D", alpha: 0.95)

    // MARK: - Button Colors
    public static let buttonPrimary = Color(hex: "#fafafa", alpha: 0.95)
    public static let buttonDisabled = Color(hex: "#fafafa", alpha: 0.15)

    // MARK: - Background Colors
    public static let backgroundBlock = Color(hex: "#222529", alpha: 1.0)
    public static let backgroundBase = Color(hex: "#000000", alpha: 1.0)
    public static let backgroundPrimary = Color(hex: "#ffffff", alpha: 0.1)
    public static let backgroundSecondary = Color(hex: "#ffffff", alpha: 0.08)
    public static let backgroundTertiary = Color(hex: "#ffffff", alpha: 0.05)
    public static let backgroundOverlay = Color(hex: "#15181A", alpha: 0.3)
    public static let backgroundAlert = Color(hex: "#FF7792", alpha: 0.08)
    public static let backgroundValid = Color(hex: "#39a699", alpha: 0.08)
    public static let backgroundBlueBanner = Color(hex: "#5792FF", alpha: 0.5)

    // MARK: - Utility Extensions
    private static func Color(hex: String, alpha: Double = 1.0) -> Color {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        return SwiftUICore.Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
