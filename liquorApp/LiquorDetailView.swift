//
//  LiquorDetailView.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import SwiftUI

struct LiquorDetailView: View {
    let liquor: Liquor
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    var body: some View {
        ZStack {
            Color.burgundy.ignoresSafeArea() // Background color
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Liquor Name
                    Text(liquor.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.charcoalBlack)
                        .padding(.top, 10)
                    
                    // Liquor Brand
                    Text(liquor.brand)
                        .font(.title3)
                        .foregroundColor(.warmBrown)
                    
                    // Liquor Type
                    Text("Type: \(liquor.type)")
                        .font(.subheadline)
                        .foregroundColor(.charcoalBlack.opacity(0.7))
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(.amberGold)
                        
                        Text(liquor.details)
                            .font(.body)
                            .foregroundColor(.charcoalBlack)
                            .lineSpacing(5)
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Snack Pairings
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Snack Pairings")
                            .font(.headline)
                            .foregroundColor(.amberGold)
                        
                        PairingsView(items: liquor.pairings.snacks, pairingType: "Snack")
                    }
                    
                    // Food Pairings
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Food Pairings")
                            .font(.headline)
                            .foregroundColor(.amberGold)
                        
                        PairingsView(items: liquor.pairings.foods, pairingType: "Food")
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.amberGold)
                            
                            Text("Liquor List")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.amberGold)
                        }
                    }
                }
            }
        }
    }
}

struct PairingsView: View {
    let items: [String]
    let pairingType: String
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption)
                    .foregroundColor(.charcoalBlack)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.lightCream.opacity(0.8))
                    .cornerRadius(8)
            }
        }
    }
}

