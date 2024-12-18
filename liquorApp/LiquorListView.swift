//
//  LiquorListView.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import SwiftUI
import SwiftData

struct LiquorListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: LiquorViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: LiquorViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            Color.burgundy.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text("Liquor Guide")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.lightCream)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                
                // Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterButton(title: "All", isSelected: viewModel.selectedType == nil) {
                            viewModel.selectedType = nil
                        }
                        ForEach(viewModel.getUniqueTypes(), id: \.self) { type in
                            FilterButton(title: type, isSelected: viewModel.selectedType == type) {
                                viewModel.selectedType = type
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Liquor List
                ScrollView {
                    if viewModel.filteredLiquors.isEmpty {
                        Text("No liquors available.")
                            .foregroundColor(.lightCream)
                            .padding()
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.filteredLiquors, id: \.id) { liquor in
                                NavigationLink(destination: LiquorDetailView(liquor: liquor)) {
                                    LiquorRowView(liquor: liquor)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct LiquorRowView: View {
    let liquor: Liquor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Uniform vertical spacing
            // Name of the Liquor
            Text(liquor.name)
                .font(.headline)
                .foregroundColor(.charcoalBlack)
                .lineLimit(1) // Ensures the text stays on one line
            
            // Brand of the Liquor
            Text(liquor.brand)
                .font(.subheadline)
                .foregroundColor(.warmBrown.opacity(0.8))
                .lineLimit(1)
            
            // Type Tag
            Text(liquor.type)
                .font(.caption)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.lightCream.opacity(0.8))
                .cornerRadius(8)
                .foregroundColor(.charcoalBlack)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensures consistent alignment
        .padding() // Inner padding
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.charcoalBlack.opacity(0.7)) // Adjusted icon color
                .padding(.leading, 10)

            TextField("Search any Liquor", text: $text)
                .foregroundColor(.charcoalBlack) // Input text color
                .placeholder(when: text.isEmpty) {
                    Text("Search any Liquor").foregroundColor(.charcoalBlack.opacity(0.5))
                }
        }
        .padding(10)
        .background(Color.lightCream) // Light cream background
        .cornerRadius(20)
        .shadow(color: Color.charcoalBlack.opacity(0.2), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

// Placeholder Modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(isSelected ? .charcoalBlack : .warmBrown)
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color.amberGold : Color.lightCream.opacity(0.5))
                .cornerRadius(20)
                .shadow(color: isSelected ? .charcoalBlack.opacity(0.3) : .clear, radius: 2, x: 0, y: 1)
        }
    }
}
