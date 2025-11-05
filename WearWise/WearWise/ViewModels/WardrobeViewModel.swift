//
//  WardrobeViewModel.swift
//  WearWise
//

import Foundation
import SwiftData

@MainActor
class WardrobeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: ClothingCategory?
    @Published var selectedFormality: FormalityLevel?

    func filteredItems(_ items: [ClothingItem]) -> [ClothingItem] {
        items.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.color.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                item.category == selectedCategory

            let matchesFormality = selectedFormality == nil ||
                item.formalityLevel == selectedFormality

            return matchesSearch && matchesCategory && matchesFormality
        }
    }

    func addItem(
        context: ModelContext,
        name: String,
        category: ClothingCategory,
        color: String,
        warmth: WarmthLevel,
        formality: FormalityLevel,
        weatherSuitability: [WeatherCondition]
    ) {
        let item = ClothingItem(
            name: name,
            category: category,
            color: color,
            warmthLevel: warmth,
            formalityLevel: formality,
            weatherSuitability: weatherSuitability
        )
        context.insert(item)
        try? context.save()
    }

    func deleteItem(context: ModelContext, item: ClothingItem) {
        context.delete(item)
        try? context.save()
    }

    func toggleFavorite(context: ModelContext, item: ClothingItem) {
        item.isFavorite.toggle()
        try? context.save()
    }

    func groupedByCategory(_ items: [ClothingItem]) -> [ClothingCategory: [ClothingItem]] {
        Dictionary(grouping: items) { $0.category }
    }
}
