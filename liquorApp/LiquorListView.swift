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
                Section {
                    SearchBar(text: $viewModel.searchText)
                }
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            FilterButton(title: "All", isSelected: viewModel.selectedType == nil) {
                                viewModel.selectedType = nil
                            }
                            ForEach(viewModel.getUniqueTypes(), id: \.self) { type in
                                FilterButton(title: type, isSelected: viewModel.selectedType == type) {
                                    viewModel.selectedType = type
                                }
                            }
                        }
                    }
                }
                
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
            Image(liquor.imageFileName ?? "placeholder")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(liquor.name).font(.headline)
                Text(liquor.brand).font(.subheadline).foregroundColor(.secondary)
                Text(liquor.type)
                    .font(.caption)
                    .padding(4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5)
            }
        }
    }
}
