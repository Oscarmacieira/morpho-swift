//
//  ContentView.swift
//  Morpho
//
//  Created by Oscar on 12/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(
                    width: 24,
                    height: 25
                )
            Text("GMorpho")
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
