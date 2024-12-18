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
    @Published var liquors: [Liquor] = []           // All liquors
    @Published var searchText: String = ""         // Search text for filtering
    @Published var selectedType: String? = nil     // Selected liquor type for filtering
    
    private var modelContext: ModelContext         // SwiftData model context
    
    // Initializer to inject the SwiftData model context
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadLiquors()
    }
    
    // Load liquors from SwiftData
    private func loadLiquors() {
        let fetchDescriptor = FetchDescriptor<Liquor>() // Fetch all Liquor objects
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            liquors = results
        } catch {
            print("Failed to fetch liquors: \(error.localizedDescription)")
        }
    }
    
    private func loadLiquorsFromJSON() {
        guard let url = Bundle.main.url(forResource: "liquors", withExtension: "json") else {
            print("Error: liquors.json file not found in the bundle!")
            return
        }
        print("JSON file found at: \(url)")

        do {
            let data = try Data(contentsOf: url)
            print("JSON data loaded successfully, size: \(data.count) bytes")

            let decodedLiquors = try JSONDecoder().decode([Liquor].self, from: data)
            print("Decoded \(decodedLiquors.count) liquors from JSON.")

            // Insert each liquor into SwiftData
            for liquor in decodedLiquors {
                modelContext.insert(liquor)
                print("Inserted liquor: \(liquor.name)")
            }
            try modelContext.save()
            print("Liquors saved to SwiftData.")

            loadLiquors() // Reload to refresh the view
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
    
    // Filter liquors based on search text and selected type
    var filteredLiquors: [Liquor] {
        var result = liquors
        if !searchText.isEmpty {
            result = result.filter { liquor in
                liquor.name.localizedCaseInsensitiveContains(searchText) ||
                liquor.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        if let selectedType = selectedType {
            result = result.filter { $0.type == selectedType }
        }
        return result
    }
    
    // Get a list of unique liquor types for filter buttons
    func getUniqueTypes() -> [String] {
        Array(Set(liquors.map { $0.type })).sorted()
    }
}
