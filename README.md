# WearWise - Smart Outfit Suggestion App

An intelligent iPhone app that suggests outfits based on:
- **Comprehensive Weather Data**: Not just temperature - includes precipitation, wind, humidity, UV index
- **Calendar Events**: Analyzes your schedule to suggest appropriate formality levels
- **Your Wardrobe**: Personalized suggestions based on clothes you actually own

## Key Features

- Real-time weather integration
- Calendar event analysis
- Wardrobe management
- Smart outfit algorithm
- Clean, intuitive UI
- Privacy-focused (all data stored locally)

## Architecture

- **Framework**: SwiftUI + Combine
- **Pattern**: MVVM
- **Persistence**: SwiftData
- **APIs**: WeatherKit, EventKit

## Project Structure

```
WearWise/
├── App/
│   └── WearWiseApp.swift
├── Models/
│   ├── ClothingItem.swift
│   ├── WeatherData.swift
│   ├── CalendarEvent.swift
│   └── OutfitSuggestion.swift
├── ViewModels/
│   ├── OutfitViewModel.swift
│   ├── WardrobeViewModel.swift
│   └── WeatherViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── WardrobeView.swift
│   ├── OutfitDetailView.swift
│   └── SettingsView.swift
├── Services/
│   ├── WeatherService.swift
│   ├── CalendarService.swift
│   └── OutfitSuggestionEngine.swift
└── Utilities/
    ├── Extensions.swift
    └── Constants.swift
```

## Getting Started

1. Open `WearWise.xcodeproj` in Xcode
2. Build and run on iOS 17+ device or simulator
3. Grant calendar and location permissions
4. Add your wardrobe items
5. Get smart outfit suggestions!
