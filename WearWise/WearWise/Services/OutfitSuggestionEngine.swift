//
//  OutfitSuggestionEngine.swift
//  WearWise
//

import Foundation

class OutfitSuggestionEngine {

    /// Generate outfit suggestions based on weather, calendar events, and wardrobe
    func generateSuggestions(
        weather: WeatherData,
        events: [CalendarEvent],
        wardrobe: [ClothingItem],
        limit: Int = 3
    ) -> [OutfitSuggestion] {

        // Determine required formality level
        let requiredFormality = events.isEmpty ?
            FormalityLevel.casual :
            (events.max { $0.inferredFormality < $1.inferredFormality }?.inferredFormality ?? .casual)

        // Determine required warmth level
        let requiredWarmth = weather.warmthRequired

        // Filter wardrobe based on weather conditions
        let weatherSuitableItems = filterByWeather(wardrobe: wardrobe, weather: weather)

        // Generate multiple outfit combinations
        var suggestions: [OutfitSuggestion] = []

        // Try to generate several outfit options
        for _ in 0..<limit * 3 {
            if let suggestion = generateSingleOutfit(
                wardrobe: weatherSuitableItems,
                weather: weather,
                requiredFormality: requiredFormality,
                requiredWarmth: requiredWarmth,
                events: events,
                excludeItems: suggestions.flatMap { $0.allItems }
            ) {
                suggestions.append(suggestion)
            }

            if suggestions.count >= limit {
                break
            }
        }

        // If we couldn't generate enough suggestions with strict criteria, relax them
        if suggestions.count < limit {
            for _ in 0..<limit {
                if let suggestion = generateSingleOutfit(
                    wardrobe: wardrobe,
                    weather: weather,
                    requiredFormality: requiredFormality,
                    requiredWarmth: requiredWarmth,
                    events: events,
                    excludeItems: suggestions.flatMap { $0.allItems },
                    relaxed: true
                ) {
                    suggestions.append(suggestion)
                }

                if suggestions.count >= limit {
                    break
                }
            }
        }

        return Array(suggestions.prefix(limit))
            .sorted { $0.confidenceScore > $1.confidenceScore }
    }

    private func generateSingleOutfit(
        wardrobe: [ClothingItem],
        weather: WeatherData,
        requiredFormality: FormalityLevel,
        requiredWarmth: WarmthLevel,
        events: [CalendarEvent],
        excludeItems: [ClothingItem],
        relaxed: Bool = false
    ) -> OutfitSuggestion? {

        let availableItems = wardrobe.filter { !excludeItems.contains(where: { $0.id == $1.id }) }

        // Try to find a dress or suit first (complete outfit)
        if let dress = selectItem(
            from: availableItems,
            category: .dress,
            formality: requiredFormality,
            warmth: requiredWarmth,
            weather: weather,
            relaxed: relaxed
        ) {
            let outerwear = weather.needsOuterwear ?
                selectItem(from: availableItems, category: .outerwear, formality: requiredFormality,
                          warmth: requiredWarmth, weather: weather, relaxed: true) : nil

            let footwear = selectItem(from: availableItems, category: .footwear,
                                     formality: requiredFormality, warmth: requiredWarmth,
                                     weather: weather, relaxed: true)

            let accessories = selectAccessories(from: availableItems, weather: weather,
                                               formality: requiredFormality)

            return createSuggestion(
                top: dress,
                bottom: nil,
                outerwear: outerwear,
                footwear: footwear,
                accessories: accessories,
                weather: weather,
                events: events,
                requiredFormality: requiredFormality,
                requiredWarmth: requiredWarmth
            )
        }

        // Select individual pieces
        guard let top = selectItem(
            from: availableItems,
            category: .top,
            formality: requiredFormality,
            warmth: requiredWarmth,
            weather: weather,
            relaxed: relaxed
        ) else {
            return nil
        }

        guard let bottom = selectItem(
            from: availableItems,
            category: .bottom,
            formality: requiredFormality,
            warmth: requiredWarmth,
            weather: weather,
            relaxed: relaxed
        ) else {
            return nil
        }

        let outerwear = weather.needsOuterwear ?
            selectItem(from: availableItems, category: .outerwear, formality: requiredFormality,
                      warmth: requiredWarmth, weather: weather, relaxed: true) : nil

        let footwear = selectItem(from: availableItems, category: .footwear,
                                 formality: requiredFormality, warmth: requiredWarmth,
                                 weather: weather, relaxed: true)

        let accessories = selectAccessories(from: availableItems, weather: weather,
                                           formality: requiredFormality)

        return createSuggestion(
            top: top,
            bottom: bottom,
            outerwear: outerwear,
            footwear: footwear,
            accessories: accessories,
            weather: weather,
            events: events,
            requiredFormality: requiredFormality,
            requiredWarmth: requiredWarmth
        )
    }

    private func selectItem(
        from wardrobe: [ClothingItem],
        category: ClothingCategory,
        formality: FormalityLevel,
        warmth: WarmthLevel,
        weather: WeatherData,
        relaxed: Bool = false
    ) -> ClothingItem? {

        let categoryItems = wardrobe.filter { $0.category == category }

        if categoryItems.isEmpty {
            return nil
        }

        // Score each item
        let scoredItems = categoryItems.map { item -> (item: ClothingItem, score: Double) in
            var score: Double = 0

            // Formality match (most important for events)
            let formalityDiff = abs(item.formalityLevel.rawValue - formality.rawValue)
            if relaxed {
                score += max(0, 5 - Double(formalityDiff))
            } else {
                score += formalityDiff <= 1 ? 10 : max(0, 5 - Double(formalityDiff))
            }

            // Warmth match
            let warmthDiff = abs(item.warmthLevel.rawValue - warmth.rawValue)
            if relaxed {
                score += max(0, 5 - Double(warmthDiff))
            } else {
                score += warmthDiff <= 1 ? 8 : max(0, 4 - Double(warmthDiff))
            }

            // Weather suitability
            let weatherConditions = weather.weatherConditions
            let suitabilityMatch = item.weatherSuitability.filter { weatherConditions.contains($0) }.count
            score += Double(suitabilityMatch) * 2

            // Favorites get bonus
            if item.isFavorite {
                score += 3
            }

            return (item, score)
        }

        // Return highest scoring item
        return scoredItems.max { $0.score < $1.score }?.item
    }

    private func selectAccessories(
        from wardrobe: [ClothingItem],
        weather: WeatherData,
        formality: FormalityLevel
    ) -> [ClothingItem] {

        var accessories: [ClothingItem] = []
        let accessoryItems = wardrobe.filter { $0.category == .accessory }

        // Add UV protection if needed
        if weather.needsUVProtection {
            if let sunglasses = accessoryItems.first(where: {
                $0.name.lowercased().contains("sunglasses") ||
                $0.name.lowercased().contains("sun glasses")
            }) {
                accessories.append(sunglasses)
            }
        }

        // Add rain accessories if needed
        if weather.needsRainGear {
            if let umbrella = accessoryItems.first(where: {
                $0.name.lowercased().contains("umbrella")
            }) {
                accessories.append(umbrella)
            }
        }

        // Add formal accessories if needed
        if formality >= .business {
            if let formalAccessory = accessoryItems.first(where: {
                $0.formalityLevel >= .business && !accessories.contains(where: { $0.id == $1.id })
            }) {
                accessories.append(formalAccessory)
            }
        }

        return accessories
    }

    private func filterByWeather(wardrobe: [ClothingItem], weather: WeatherData) -> [ClothingItem] {
        let weatherConditions = weather.weatherConditions

        return wardrobe.filter { item in
            // If item has no weather specifications, it's suitable for all weather
            if item.weatherSuitability.isEmpty {
                return true
            }

            // Check if item is suitable for current weather
            return item.weatherSuitability.contains { weatherConditions.contains($0) } ||
                   item.weatherSuitability.contains { condition in
                // General suitability
                (condition == .sunny && !weather.needsRainGear) ||
                (condition == .cloudy && !weather.needsRainGear)
            }
        }
    }

    private func createSuggestion(
        top: ClothingItem?,
        bottom: ClothingItem?,
        outerwear: ClothingItem?,
        footwear: ClothingItem?,
        accessories: [ClothingItem],
        weather: WeatherData,
        events: [CalendarEvent],
        requiredFormality: FormalityLevel,
        requiredWarmth: WarmthLevel
    ) -> OutfitSuggestion {

        // Calculate confidence score
        var confidence: Double = 0
        var reasons: [String] = []

        // Check formality match
        let outfitItems = [top, bottom, outerwear, footwear].compactMap { $0 }
        if !outfitItems.isEmpty {
            let avgFormality = outfitItems.map { $0.formalityLevel.rawValue }.reduce(0, +) / outfitItems.count
            let formalityDiff = abs(avgFormality - requiredFormality.rawValue)

            if formalityDiff <= 1 {
                confidence += 40
                reasons.append("Perfect formality match for your events")
            } else {
                confidence += max(0, 40 - Double(formalityDiff) * 10)
            }
        }

        // Check warmth match
        let avgWarmth = outfitItems.map { $0.warmthLevel.rawValue }.reduce(0, +) / max(outfitItems.count, 1)
        let warmthDiff = abs(avgWarmth - requiredWarmth.rawValue)

        if warmthDiff <= 1 {
            confidence += 30
            reasons.append("Ideal warmth for \(Int(weather.temperature))°C")
        } else {
            confidence += max(0, 30 - Double(warmthDiff) * 8)
        }

        // Check weather suitability
        if outerwear != nil && weather.needsOuterwear {
            confidence += 15
            reasons.append("Includes outerwear for the weather")
        } else if outerwear == nil && !weather.needsOuterwear {
            confidence += 10
        }

        // Check rain gear
        if weather.needsRainGear && accessories.contains(where: { $0.name.lowercased().contains("umbrella") }) {
            confidence += 10
            reasons.append("Rain protection included")
        }

        // Check UV protection
        if weather.needsUVProtection && accessories.contains(where: { $0.name.lowercased().contains("sunglasses") }) {
            confidence += 5
            reasons.append("UV protection included")
        }

        let reasoning = reasons.isEmpty ? "Basic outfit suggestion" : reasons.joined(separator: ". ")

        return OutfitSuggestion(
            top: top,
            bottom: bottom,
            outerwear: outerwear,
            footwear: footwear,
            accessories: accessories,
            occasion: events.first,
            weather: weather,
            confidenceScore: min(confidence, 100),
            reasoning: reasoning
        )
    }
}
