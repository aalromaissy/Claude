//
//  HomeView.swift
//  WearWise
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var outfitViewModel: OutfitViewModel
    let wardrobeItems: [ClothingItem]

    @State private var showingDetail = false
    @State private var selectedSuggestion: OutfitSuggestion?

    var body: some View {
        NavigationStack {
            ZStack {
                if outfitViewModel.isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Analyzing weather and events...")
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                } else if let error = outfitViewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await outfitViewModel.refresh(wardrobe: wardrobeItems)
                        }
                    }
                } else if outfitViewModel.suggestions.isEmpty {
                    EmptyStateView {
                        Task {
                            await outfitViewModel.generateSuggestions(wardrobe: wardrobeItems)
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Weather summary
                            if let weather = outfitViewModel.suggestions.first?.weather {
                                WeatherCard(weather: weather)
                                    .padding(.horizontal)
                            }

                            // Outfit suggestions
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Suggested Outfits")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)

                                ForEach(outfitViewModel.suggestions) { suggestion in
                                    OutfitCard(suggestion: suggestion)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            selectedSuggestion = suggestion
                                            showingDetail = true
                                        }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("WearWise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await outfitViewModel.refresh(wardrobe: wardrobeItems)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .accessibilityLabel("Refresh Suggestions")
                    }
                    .disabled(outfitViewModel.isLoading)
                }
            }
            .sheet(item: $selectedSuggestion) { suggestion in
                OutfitDetailView(suggestion: suggestion)
            }
            .task {
                if outfitViewModel.suggestions.isEmpty && !wardrobeItems.isEmpty {
                    await outfitViewModel.generateSuggestions(wardrobe: wardrobeItems)
                }
            }
        }
    }
}

struct WeatherCard: View {
    let weather: WeatherData

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: weatherIcon)
                    .font(.largeTitle)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text("\(Int(weather.temperature))°C")
                        .font(.title)
                        .bold()
                    Text(weather.description.capitalized)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer")
                        Text("Feels like \(Int(weather.feelsLike))°C")
                    }
                    .font(.caption)

                    HStack(spacing: 4) {
                        Image(systemName: "humidity")
                        Text("\(weather.humidity)%")
                    }
                    .font(.caption)

                    HStack(spacing: 4) {
                        Image(systemName: "wind")
                        Text("\(Int(weather.windSpeed)) m/s")
                    }
                    .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    var weatherIcon: String {
        if weather.precipitation > 0 {
            return weather.temperature < 0 ? "snowflake" : "cloud.rain.fill"
        } else if weather.cloudCover < 20 {
            return "sun.max.fill"
        } else if weather.cloudCover > 70 {
            return "cloud.fill"
        } else {
            return "cloud.sun.fill"
        }
    }
}

struct OutfitCard: View {
    let suggestion: OutfitSuggestion

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let occasion = suggestion.occasion {
                        Text(occasion.title)
                            .font(.headline)
                        Text(occasion.startDate, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Daily Outfit")
                            .font(.headline)
                    }
                }

                Spacer()

                // Confidence badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                    Text("\(Int(suggestion.confidenceScore))%")
                        .font(.caption)
                        .bold()
                }
                .foregroundColor(.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(8)
            }

            // Outfit items
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(suggestion.allItems) { item in
                        ClothingItemPreview(item: item)
                    }
                }
            }

            Text(suggestion.reasoning)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct ClothingItemPreview: View {
    let item: ClothingItem

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color(hex: item.color) ?? .gray)
                    .frame(width: 50, height: 50)

                Image(systemName: item.category.icon)
                    .foregroundColor(.white)
            }

            Text(item.name)
                .font(.caption2)
                .lineLimit(1)
                .frame(width: 60)
        }
    }
}

struct EmptyStateView: View {
    let onRefresh: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Get Your Outfit Suggestion")
                .font(.title2)
                .bold()

            Text("Tap the button below to get personalized outfit suggestions based on weather and your calendar.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button(action: onRefresh) {
                Label("Generate Suggestions", systemImage: "sparkles")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct ErrorView: View {
    let error: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Oops!")
                .font(.title2)
                .bold()

            Text(error)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}
