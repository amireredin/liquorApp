//
//  Liquor.swift
//  liquorApp
//
//  Created by Amir Hossein on 16/12/24.
//

import Foundation
import SwiftData

import Foundation
import SwiftData

@Model
class Liquor: Identifiable, Codable { // Codable ensures JSON compatibility
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

    enum CodingKeys: CodingKey {
        case id, name, type, brand, details, pairings, imageFileName
    }

    // SwiftData initializer
    init(name: String, type: String, brand: String, details: String,
         pairings: Pairings, imageFileName: String? = "placeholder") {
        self.name = name
        self.type = type
        self.brand = brand
        self.details = details
        self.pairings = pairings
        self.imageFileName = imageFileName
    }

    // Codable methods
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.details = try container.decode(String.self, forKey: .details)
        self.pairings = try container.decode(Pairings.self, forKey: .pairings)
        self.imageFileName = try container.decodeIfPresent(String.self, forKey: .imageFileName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(brand, forKey: .brand)
        try container.encode(details, forKey: .details)
        try container.encode(pairings, forKey: .pairings)
        try container.encode(imageFileName, forKey: .imageFileName)
    }
}
