//
//  LiquorDetailView.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//


import SwiftUI

struct LiquorDetailView: View {
    let liquor: Liquor
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Liquor Name
                Text(liquor.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityLabel("Liquor Name: \(liquor.name)")
                
                // Liquor Brand
                Text(liquor.brand)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Brand: \(liquor.brand)")
                
                // Liquor Type
                Text("Type: \(liquor.type)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Type: \(liquor.type)")

                // About Section
                Section(header: Text("About")
                    .font(.headline)
                    .accessibilityLabel("About Section")) {
                    Text(liquor.details)
                        .accessibilityLabel("Details: \(liquor.details)")
                }
                
                // Snack Pairings
                Section(header: Text("Snack Pairings")
                    .font(.headline)
                    .accessibilityLabel("Snack Pairings Section")) {
                    PairingsView(items: liquor.pairings.snacks, pairingType: "Snack")
                }
                
                // Food Pairings
                Section(header: Text("Food Pairings")
                    .font(.headline)
                    .accessibilityLabel("Food Pairings Section")) {
                    PairingsView(items: liquor.pairings.foods, pairingType: "Food")
                }
            }
            .padding()
            .accessibilityElement(children: .contain) // Allows all children elements to be accessible
        }
        .accessibilityLabel("\(liquor.name) details")
        .accessibilityHint("Contains details, snack pairings, and food pairings for \(liquor.name)")
    }
}

struct PairingsView: View {
    let items: [String]
    let pairingType: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        .accessibilityLabel("\(pairingType) pairing: \(item)")
                        .accessibilityHint("This is a recommended \(pairingType.lowercased()) for the liquor")
                }
            }
        }
        .accessibilityElement(children: .contain) // Makes pairings accessible as separate elements
    }
}

#Preview {
    LiquorDetailView(liquor: Liquor.sampleLiquors()[0])
}
