//
//  OutfitSuggestion.swift
//  WearWise
//

import Foundation

struct OutfitSuggestion: Identifiable {
    let id: UUID
    let top: ClothingItem?
    let bottom: ClothingItem?
    let outerwear: ClothingItem?
    let footwear: ClothingItem?
    let accessories: [ClothingItem]
    let occasion: CalendarEvent?
    let weather: WeatherData
    let confidenceScore: Double
    let reasoning: String
    let timestamp: Date

    init(
        id: UUID = UUID(),
        top: ClothingItem?,
        bottom: ClothingItem?,
        outerwear: ClothingItem?,
        footwear: ClothingItem?,
        accessories: [ClothingItem] = [],
        occasion: CalendarEvent?,
        weather: WeatherData,
        confidenceScore: Double,
        reasoning: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.top = top
        self.bottom = bottom
        self.outerwear = outerwear
        self.footwear = footwear
        self.accessories = accessories
        self.occasion = occasion
        self.weather = weather
        self.confidenceScore = confidenceScore
        self.reasoning = reasoning
        self.timestamp = timestamp
    }

    var allItems: [ClothingItem] {
        var items: [ClothingItem] = []
        if let top = top { items.append(top) }
        if let bottom = bottom { items.append(bottom) }
        if let outerwear = outerwear { items.append(outerwear) }
        if let footwear = footwear { items.append(footwear) }
        items.append(contentsOf: accessories)
        return items
    }

    var isComplete: Bool {
        // At minimum, need a top (or dress) and bottom (or dress)
        (top != nil && bottom != nil) ||
        (allItems.contains { $0.category == .dress || $0.category == .suit })
    }

    var formality: FormalityLevel {
        let levels = allItems.map { $0.formalityLevel }
        if levels.isEmpty { return .casual }

        // Use the highest formality level from the outfit
        return levels.max() ?? .casual
    }

    var warmth: WarmthLevel {
        let levels = allItems.map { $0.warmthLevel }
        if levels.isEmpty { return .medium }

        // Average warmth level
        let sum = levels.reduce(0) { $0 + $1.rawValue }
        let avg = Double(sum) / Double(levels.count)
        return WarmthLevel(rawValue: Int(avg.rounded())) ?? .medium
    }
}
