//
//  LiquorGuideApp.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//


import SwiftUI
import SwiftData

@main
struct LiquorGuideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Liquor.self])
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            LiquorListView(modelContext: modelContext)
        }
    }
}
