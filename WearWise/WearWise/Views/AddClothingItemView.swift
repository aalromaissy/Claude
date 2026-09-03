//
//  AddClothingItemView.swift
//  WearWise
//

import SwiftUI
import SwiftData

struct AddClothingItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var selectedCategory: ClothingCategory = .top
    @State private var selectedColor = "#808080"
    @State private var selectedWarmth: WarmthLevel = .medium
    @State private var selectedFormality: FormalityLevel = .casual
    @State private var selectedWeatherConditions: Set<WeatherCondition> = []

    let predefinedColors = [
        "Black": "#000000",
        "White": "#FFFFFF",
        "Gray": "#808080",
        "Red": "#FF0000",
        "Blue": "#0000FF",
        "Navy": "#000080",
        "Green": "#008000",
        "Yellow": "#FFFF00",
        "Orange": "#FFA500",
        "Purple": "#800080",
        "Pink": "#FFC0CB",
        "Brown": "#8B4513",
        "Beige": "#F5F5DC",
        "Khaki": "#C3B091"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Item Name", text: $name)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ClothingCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }

                Section("Color") {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 60))
                    ], spacing: 12) {
                        ForEach(Array(predefinedColors.keys.sorted()), id: \.self) { colorName in
                            ColorButton(
                                name: colorName,
                                hexValue: predefinedColors[colorName]!,
                                isSelected: selectedColor == predefinedColors[colorName]!,
                                action: {
                                    selectedColor = predefinedColors[colorName]!
                                }
                            )
                        }
                    }
                }

                Section("Properties") {
                    Picker("Warmth Level", selection: $selectedWarmth) {
                        ForEach(WarmthLevel.allCases, id: \.self) { warmth in
                            Text(warmth.description).tag(warmth)
                        }
                    }

                    Picker("Formality", selection: $selectedFormality) {
                        ForEach(FormalityLevel.allCases, id: \.self) { formality in
                            Text(formality.description).tag(formality)
                        }
                    }
                }

                Section("Weather Suitability") {
                    Text("Select weather conditions this item is suitable for")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ForEach(WeatherCondition.allCases, id: \.self) { condition in
                        Toggle(isOn: Binding(
                            get: { selectedWeatherConditions.contains(condition) },
                            set: { isSelected in
                                if isSelected {
                                    selectedWeatherConditions.insert(condition)
                                } else {
                                    selectedWeatherConditions.remove(condition)
                                }
                            }
                        )) {
                            Label(condition.rawValue, systemImage: condition.icon)
                        }
                    }
                }
            }
            .navigationTitle("Add Clothing Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func addItem() {
        let item = ClothingItem(
            name: name,
            category: selectedCategory,
            color: selectedColor,
            warmthLevel: selectedWarmth,
            formalityLevel: selectedFormality,
            weatherSuitability: Array(selectedWeatherConditions)
        )

        modelContext.insert(item)
        try? modelContext.save()
        dismiss()
    }
}

struct ColorButton: View {
    let name: String
    let hexValue: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(Color(hex: hexValue) ?? .gray)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: isSelected ? 3 : 0)
                        )

                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(hexValue == "#FFFFFF" ? .black : .white)
                            .font(.caption)
                    }
                }

                Text(name)
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
        }
        .accessibilityLabel(name)
        .buttonStyle(.plain)
    }
}
