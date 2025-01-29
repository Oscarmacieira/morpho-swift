//
//  IconImage.swift
//  BlueUI
//
//  Created by Oscar on 19/01/2025.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct IconImage: View {
    public let name: String
    public let size: CGFloat
    
    public init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }

    public var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
