//
//  Color+Extensions.swift
//  Morpho
//
//  Created by Oscar on 12/01/2025.
//

import SwiftUI

extension Color {
    var random: Color {
            .init(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}
