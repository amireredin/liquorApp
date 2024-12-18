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
    
    // Custom initializer to handle modelContext
    init(modelContext: ModelContext) {
        let viewModelInstance: LiquorViewModel = LiquorViewModel(modelContext: modelContext)
        _viewModel = StateObject(wrappedValue: viewModelInstance)
    }
    
    var body: some View {
        NavigationStack {
            List {
                // 🔍 Search Bar Section
                Section {
                    SearchBar(text: $viewModel.searchText)
                }
                
                // 🗂️ Filter Buttons Section
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            // "All" Filter Button
                            FilterButton(title: "All", isSelected: viewModel.selectedType == nil) {
                                viewModel.selectedType = nil
                            }

                            // Dynamic Filter Buttons for Each Liquor Type
                            ForEach(viewModel.getUniqueTypes(), id: \.self) { type in
                                FilterButton(title: type, isSelected: viewModel.selectedType == type) {
                                    viewModel.selectedType = type
                                }
                            }
                        }
                    }
                }
                
                // 📜 Liquor List Section
                Section {
                    ForEach(viewModel.filteredLiquors, id: \.id) { liquor in
                        NavigationLink(destination: LiquorDetailView(liquor: liquor)) {
                            LiquorRowView(liquor: liquor)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Liquor Guide")
        }
    }
}

struct LiquorRowView: View {
    let liquor: Liquor
    
    var body: some View {
        HStack(spacing: 15) {
            // 🖼️ Liquor Image
            Image(liquor.imageFileName ?? "placeholder")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 3)

            // 📝 Liquor Details
            VStack(alignment: .leading, spacing: 5) {
                Text(liquor.name)
                    .font(.headline)

                Text(liquor.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(liquor.type)
                    .font(.caption)
                    .padding(4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .padding(.horizontal, 10)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(10)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(10)
        }
    }
}
