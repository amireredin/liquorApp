//
//  LiquorViewModel.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import Foundation
import SwiftData
import Combine

@MainActor
class LiquorViewModel: ObservableObject {
    @Published var liquors: [Liquor] = []
    @Published var filteredLiquors: [Liquor] = []
    @Published var searchText: String = ""
    @Published var selectedType: String? = nil
    
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupObservers()
        loadLiquors()
    }
    
    private func setupObservers() {
        $searchText
            .combineLatest($selectedType)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.filterLiquors()
            }
            .store(in: &cancellables)
    }
    
    private func loadLiquors() {
        let fetchDescriptor = FetchDescriptor<Liquor>()
        if let results = try? modelContext.fetch(fetchDescriptor) {
            liquors = results
            filteredLiquors = liquors
        } else {
            print("Failed to load liquors")
        }
    }
    
    private func filterLiquors() {
        filteredLiquors = liquors.filter { liquor in
            let matchesSearch = searchText.isEmpty ||
                                liquor.name.localizedCaseInsensitiveContains(searchText) ||
                                liquor.brand.localizedCaseInsensitiveContains(searchText)
            
            let matchesType = selectedType == nil || liquor.type == selectedType
            
            return matchesSearch && matchesType
        }
    }
    
    func getUniqueTypes() -> [String] {
        Array(Set(liquors.map { $0.type })).sorted()
    }
}
