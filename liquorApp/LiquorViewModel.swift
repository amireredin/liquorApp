//
//  LiquorViewModel.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class LiquorViewModel: ObservableObject {
    @Published var liquors: [Liquor] = []
    @Published var searchText: String = ""
    @Published var selectedType: String? = nil
    
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupObservers()
        loadLiquorsFromJSON()
    }
    
    private func setupObservers() {
        $searchText
            .combineLatest($selectedType)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterLiquors()
            }
            .store(in: &cancellables)
    }
    
    func loadLiquorsFromJSON() {
        guard let url = Bundle.main.url(forResource: "liquors", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            // Decode as an array of Liquor
            let loadedLiquors = try decoder.decode([Liquor].self, from: data)
            
            // Clear existing data in SwiftData
            let fetchDescriptor = FetchDescriptor<Liquor>()
            let existingLiquors = try? modelContext.fetch(fetchDescriptor)
            existingLiquors?.forEach { modelContext.delete($0) }
            
            // Insert new liquors
            loadedLiquors.forEach { liquor in
                modelContext.insert(liquor)
            }
            
            try modelContext.save()
            
            self.liquors = loadedLiquors
        } catch {
            print("Error loading liquors from JSON: \(error)")
            print("Detailed error: \(error.localizedDescription)")
        }
    }
    
    private func filterLiquors() {
        let filteredResults = liquors.filter { liquor in
            let searchMatch = searchText.isEmpty ||
            liquor.name.localizedCaseInsensitiveContains(searchText) ||
            liquor.brand.localizedCaseInsensitiveContains(searchText)
            
            let typeMatch = selectedType == nil || liquor.type == selectedType
            
            return searchMatch && typeMatch
        }
        
        self.liquors = filteredResults
    }
    
    func getUniqueTypes() -> [String] {
        return Array(Set(liquors.map { $0.type })).sorted()
    }
}
