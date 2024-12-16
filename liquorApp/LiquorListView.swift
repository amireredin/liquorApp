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
        NavigationStack {
            List {
                // Search Section
                Section {
                    SearchBar(text: $viewModel.searchText)
                }
                
                // Type Filter Section
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            FilterButton(
                                title: "All",
                                isSelected: viewModel.selectedType == nil
                            ) {
                                viewModel.selectedType = nil
                            }
                            
                            ForEach(viewModel.getUniqueTypes(), id: \.self) { type in
                                FilterButton(
                                    title: type,
                                    isSelected: viewModel.selectedType == type
                                ) {
                                    viewModel.selectedType = type
                                }
                            }
                        }
                    }
                }
                
                // Liquor List Section
                Section {
                    ForEach(viewModel.liquors, id: \.id) { liquor in
                        NavigationLink(destination: LiquorDetailView(liquor: liquor)) {
                            LiquorRowView(liquor: liquor)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Liquor Guide")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Future: Add new liquor functionality
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct LiquorRowView: View {
    let liquor: Liquor
    
    var body: some View {
        HStack(spacing: 15) {
            Image(liquor.imageFileName ?? "placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(liquor.name)
                    .font(.headline)
                Text(liquor.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(liquor.type)
                        .font(.caption)
                        .padding(4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(5)
                    
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.secondary.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(10)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search Liquors", text: $text)
                .autocorrectionDisabled()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
