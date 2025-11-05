//
//  OutfitDetailView.swift
//  WearWise
//

import SwiftUI

struct OutfitDetailView: View {
    let suggestion: OutfitSuggestion
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        if let occasion = suggestion.occasion {
                            Text(occasion.title)
                                .font(.title)
                                .bold()

                            HStack {
                                Image(systemName: "calendar")
                                Text(occasion.startDate, style: .date)
                                Text("-")
                                Text(occasion.startDate, style: .time)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                            if let location = occasion.location {
                                HStack {
                                    Image(systemName: "location")
                                    Text(location)
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        } else {
                            Text("Today's Outfit")
                                .font(.title)
                                .bold()
                        }

                        // Confidence score
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Confidence: \(Int(suggestion.confidenceScore))%")
                                .bold()
                        }
                        .foregroundColor(.orange)
                    }
                    .padding(.horizontal)

                    Divider()

                    // Weather info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weather Conditions")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 20) {
                            WeatherInfoItem(
                                icon: "thermometer",
                                title: "Temperature",
                                value: "\(Int(suggestion.weather.temperature))°C"
                            )

                            WeatherInfoItem(
                                icon: "humidity",
                                title: "Humidity",
                                value: "\(suggestion.weather.humidity)%"
                            )

                            WeatherInfoItem(
                                icon: "wind",
                                title: "Wind",
                                value: "\(Int(suggestion.weather.windSpeed)) m/s"
                            )
                        }
                        .padding(.horizontal)

                        if suggestion.weather.precipitation > 0 {
                            HStack {
                                Image(systemName: "cloud.rain")
                                    .foregroundColor(.blue)
                                Text("Precipitation expected: \(String(format: "%.1f", suggestion.weather.precipitation))mm")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                        }

                        if suggestion.weather.uvIndex > 6 {
                            HStack {
                                Image(systemName: "sun.max")
                                    .foregroundColor(.orange)
                                Text("High UV index: \(Int(suggestion.weather.uvIndex)) - UV protection recommended")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal)
                        }
                    }

                    Divider()

                    // Outfit items
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Outfit Details")
                            .font(.headline)
                            .padding(.horizontal)

                        if let top = suggestion.top {
                            ClothingDetailCard(item: top)
                        }

                        if let bottom = suggestion.bottom {
                            ClothingDetailCard(item: bottom)
                        }

                        if let outerwear = suggestion.outerwear {
                            ClothingDetailCard(item: outerwear)
                        }

                        if let footwear = suggestion.footwear {
                            ClothingDetailCard(item: footwear)
                        }

                        if !suggestion.accessories.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Accessories")
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal)

                                ForEach(suggestion.accessories) { accessory in
                                    ClothingDetailCard(item: accessory)
                                }
                            }
                        }
                    }

                    Divider()

                    // Reasoning
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why This Outfit?")
                            .font(.headline)

                        Text(suggestion.reasoning)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct WeatherInfoItem: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)

            Text(value)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ClothingDetailCard: View {
    let item: ClothingItem

    var body: some View {
        HStack(spacing: 16) {
            // Color indicator
            ZStack {
                Circle()
                    .fill(Color(hex: item.color) ?? .gray)
                    .frame(width: 60, height: 60)

                Image(systemName: item.category.icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)

                HStack {
                    Text(item.category.rawValue)
                    Text("•")
                    Text(item.color)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    Label(item.warmthLevel.description, systemImage: "thermometer")
                    Label(item.formalityLevel.description, systemImage: "star")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            if item.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
