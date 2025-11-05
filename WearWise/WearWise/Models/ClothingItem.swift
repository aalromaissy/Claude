//
//  ClothingItem.swift
//  WearWise
//

import Foundation
import SwiftData

@Model
final class ClothingItem: Identifiable {
    var id: UUID
    var name: String
    var category: ClothingCategory
    var color: String
    var warmthLevel: WarmthLevel
    var formalityLevel: FormalityLevel
    var weatherSuitability: [WeatherCondition]
    var imageName: String?
    var dateAdded: Date
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: ClothingCategory,
        color: String,
        warmthLevel: WarmthLevel,
        formalityLevel: FormalityLevel,
        weatherSuitability: [WeatherCondition],
        imageName: String? = nil,
        dateAdded: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.color = color
        self.warmthLevel = warmthLevel
        self.formalityLevel = formalityLevel
        self.weatherSuitability = weatherSuitability
        self.imageName = imageName
        self.dateAdded = dateAdded
        self.isFavorite = isFavorite
    }
}

enum ClothingCategory: String, Codable, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
    case outerwear = "Outerwear"
    case footwear = "Footwear"
    case accessory = "Accessory"
    case dress = "Dress"
    case suit = "Suit"

    var icon: String {
        switch self {
        case .top: return "tshirt"
        case .bottom: return "figure.walk"
        case .outerwear: return "cloud.rain"
        case .footwear: return "shoe"
        case .accessory: return "eyeglasses"
        case .dress: return "figure.dress.line.vertical.figure"
        case .suit: return "briefcase"
        }
    }
}

enum WarmthLevel: Int, Codable, CaseIterable, Comparable {
    case veryLight = 1
    case light = 2
    case medium = 3
    case warm = 4
    case veryWarm = 5

    var description: String {
        switch self {
        case .veryLight: return "Very Light"
        case .light: return "Light"
        case .medium: return "Medium"
        case .warm: return "Warm"
        case .veryWarm: return "Very Warm"
        }
    }

    static func < (lhs: WarmthLevel, rhs: WarmthLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

enum FormalityLevel: Int, Codable, CaseIterable, Comparable {
    case casual = 1
    case smartCasual = 2
    case business = 3
    case businessFormal = 4
    case formal = 5

    var description: String {
        switch self {
        case .casual: return "Casual"
        case .smartCasual: return "Smart Casual"
        case .business: return "Business"
        case .businessFormal: return "Business Formal"
        case .formal: return "Formal"
        }
    }

    static func < (lhs: FormalityLevel, rhs: FormalityLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

enum WeatherCondition: String, Codable, CaseIterable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case snowy = "Snowy"
    case windy = "Windy"
    case hot = "Hot"
    case cold = "Cold"
    case humid = "Humid"

    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .snowy: return "snowflake"
        case .windy: return "wind"
        case .hot: return "thermometer.sun.fill"
        case .cold: return "thermometer.snowflake"
        case .humid: return "humidity.fill"
        }
    }
}
