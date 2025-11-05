//
//  Constants.swift
//  WearWise
//

import Foundation

enum AppConstants {
    // API
    static let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5"

    // Storage Keys
    static let weatherAPIKeyKey = "weatherAPIKey"
    static let useMetricKey = "useMetric"

    // Defaults
    static let defaultSuggestionCount = 3
    static let defaultLocationAccuracy = 1000.0 // meters

    // Weather thresholds
    static let hotTemperature = 25.0 // Celsius
    static let coldTemperature = 10.0 // Celsius
    static let heavyRainThreshold = 5.0 // mm
    static let highWindThreshold = 10.0 // m/s
    static let highHumidityThreshold = 70 // percentage
    static let highUVThreshold = 6.0

    // Outfit generation
    static let maxOutfitGenerationAttempts = 10
    static let minConfidenceScore = 50.0
}

enum SampleData {
    static func createSampleWardrobe() -> [ClothingItem] {
        [
            ClothingItem(
                name: "White T-Shirt",
                category: .top,
                color: "#FFFFFF",
                warmthLevel: .veryLight,
                formalityLevel: .casual,
                weatherSuitability: [.sunny, .hot]
            ),
            ClothingItem(
                name: "Blue Jeans",
                category: .bottom,
                color: "#0000FF",
                warmthLevel: .medium,
                formalityLevel: .casual,
                weatherSuitability: []
            ),
            ClothingItem(
                name: "Black Blazer",
                category: .outerwear,
                color: "#000000",
                warmthLevel: .warm,
                formalityLevel: .business,
                weatherSuitability: []
            ),
            ClothingItem(
                name: "Sneakers",
                category: .footwear,
                color: "#FFFFFF",
                warmthLevel: .light,
                formalityLevel: .casual,
                weatherSuitability: [.sunny]
            ),
            ClothingItem(
                name: "Umbrella",
                category: .accessory,
                color: "#000000",
                warmthLevel: .veryLight,
                formalityLevel: .casual,
                weatherSuitability: [.rainy]
            ),
            ClothingItem(
                name: "Sunglasses",
                category: .accessory,
                color: "#000000",
                warmthLevel: .veryLight,
                formalityLevel: .casual,
                weatherSuitability: [.sunny]
            )
        ]
    }
}
