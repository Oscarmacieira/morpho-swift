//
//  ProgressBar.swift
//  BlueUI
//
//  Created by Oscar on 19/01/2025.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct ProgressBar: View {
    var percentage: Double
    var fillColor: Color
    var backgroundColor: Color
    var height: CGFloat

    public init(
        percentage: Double,
        fillColor: Color = .blue,
        backgroundColor: Color = .gray.opacity(0.2),
        height: CGFloat = 10
    ) {
        self.percentage = min(max(percentage, 0), 1)
        self.fillColor = fillColor
        self.backgroundColor = backgroundColor
        self.height = height
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(fillColor)
                    .frame(width: geometry.size.width * percentage, height: height)
            }
        }
        .frame(height: height)
    }
}
