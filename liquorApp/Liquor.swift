//
//  Liquor.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import Foundation
import SwiftData

@Model
class Liquor: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var type: String
    var brand: String
    var details: String
    var pairings: Pairings
    var imageFileName: String?
    
    struct Pairings: Codable {
        var snacks: [String]
        var foods: [String]
    }
    
    init(name: String, type: String, brand: String, details: String,
         pairings: Pairings, imageFileName: String? = "placeholder") {
        self.name = name
        self.type = type
        self.brand = brand
        self.details = details
        self.pairings = pairings
        self.imageFileName = imageFileName
    }
}


extension Liquor {
    static func sampleLiquors() -> [Liquor] {
        return [
            Liquor(
                name: "Johnnie Walker Black Label",
                type: "Whiskey",
                brand: "Johnnie Walker",
                details: "A blended Scotch whisky with smoky and sweet flavors.",
                pairings: Pairings(
                    snacks: ["Dark chocolate", "Smoked nuts"],
                    foods: ["Grilled steak", "Cheese platter"]
                ),
                imageFileName: "johnnie_walker_black_label.jpg"
            )
        ]
    }
}
