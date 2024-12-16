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
                Text(liquor.name).font(.largeTitle).fontWeight(.bold)
                Text(liquor.brand).font(.title2).foregroundColor(.secondary)
                Text("Type: \(liquor.type)").font(.subheadline).foregroundColor(.secondary)
                
                Section(header: Text("About").font(.headline)) {
                    Text(liquor.details)
                }
                
                Section(header: Text("Snack Pairings").font(.headline)) {
                    PairingsView(items: liquor.pairings.snacks)
                }
                
                Section(header: Text("Food Pairings").font(.headline)) {
                    PairingsView(items: liquor.pairings.foods)
                }
            }
            .padding()
        }
    }
}

struct PairingsView: View {
    let items: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }
}
