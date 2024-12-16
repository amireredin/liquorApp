//
//  Liquor.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import Foundation
import SwiftData

@Model
class Liquor: Identifiable, Codable {
    @Attribute(.unique) var id: UUID
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
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, brand, details, pairings, imageFileName
    }
    
    init(name: String, type: String, brand: String, details: String,
         pairings: Pairings, imageFileName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.brand = brand
        self.details = details
        self.pairings = pairings
        self.imageFileName = imageFileName
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.details = try container.decode(String.self, forKey: .details)
        self.pairings = try container.decode(Pairings.self, forKey: .pairings)
        self.imageFileName = try container.decodeIfPresent(String.self, forKey: .imageFileName)
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(brand, forKey: .brand)
        try container.encode(details, forKey: .details)
        try container.encode(pairings, forKey: .pairings)
        try container.encodeIfPresent(imageFileName, forKey: .imageFileName)
    }
}

// Extension for sample data and helper methods
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
