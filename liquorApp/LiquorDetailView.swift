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
                // Header Section
                Group {
                    Text(liquor.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(liquor.brand)
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(liquor.type)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Description Section
                Section(header: Text("About").font(.headline)) {
                    Text(liquor.details)
                        .font(.body)
                }
                
                // Pairings Section
                Section(header: Text("Snack Pairings").font(.headline)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(liquor.pairings.snacks, id: \.self) { snack in
                                Text(snack)
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Section(header: Text("Food Pairings").font(.headline)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(liquor.pairings.foods, id: \.self) { food in
                                Text(food)
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
