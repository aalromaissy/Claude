# WearWise - Technical Architecture

## Overview

WearWise is built using modern iOS development practices with SwiftUI, following the MVVM (Model-View-ViewModel) architectural pattern. The app integrates weather data, calendar events, and user wardrobe information to generate intelligent outfit suggestions.

## Architecture Pattern: MVVM

```
┌─────────────────────────────────────────────────┐
│                    Views                        │
│  (HomeView, WardrobeView, SettingsView, etc.)   │
└────────────────┬────────────────────────────────┘
                 │ Observes
                 ↓
┌─────────────────────────────────────────────────┐
│                 ViewModels                       │
│    (OutfitViewModel, WardrobeViewModel)         │
└────────────┬─────────────────┬──────────────────┘
             │                 │
             │ Uses            │ Uses
             ↓                 ↓
┌──────────────────┐  ┌────────────────────────┐
│     Services     │  │       Models           │
│  - Weather       │  │  - ClothingItem        │
│  - Calendar      │  │  - WeatherData         │
│  - Suggestion    │  │  - CalendarEvent       │
│    Engine        │  │  - OutfitSuggestion    │
└──────────────────┘  └────────────────────────┘
```

## Layer Breakdown

### 1. Models Layer

**Purpose**: Data structures and business logic

**Components**:
- `ClothingItem`: SwiftData model for wardrobe items
  - Properties: category, color, warmth, formality, weather suitability
  - Persisted locally using SwiftData

- `WeatherData`: Weather information from API
  - Comprehensive weather metrics
  - Derived properties for outfit suggestions

- `CalendarEvent`: Calendar event representation
  - Formality inference algorithm
  - Event type detection

- `OutfitSuggestion`: Complete outfit with reasoning
  - Confidence scoring
  - Reasoning explanation

**Design Decisions**:
- Used `@Model` macro for SwiftData integration
- Enums for categorical data (type-safe)
- Computed properties for derived values

### 2. Services Layer

**Purpose**: External integrations and business logic

**Components**:

#### WeatherService
- **Responsibility**: Fetch and parse weather data
- **API**: OpenWeatherMap
- **Features**:
  - Current weather
  - UV index
  - Weather forecasting
- **Error Handling**: Comprehensive error types
- **Async/Await**: Modern concurrency

#### CalendarService
- **Responsibility**: Calendar integration
- **Framework**: EventKit
- **Features**:
  - Permission management
  - Event fetching
  - Event filtering
- **Privacy**: Read-only access

#### OutfitSuggestionEngine
- **Responsibility**: Core suggestion algorithm
- **Algorithm**:
  1. Analyze weather requirements
  2. Determine formality from events
  3. Filter wardrobe by weather
  4. Score items for compatibility
  5. Generate outfit combinations
  6. Calculate confidence scores
  7. Provide reasoning

**Scoring Algorithm**:
```swift
Score = Formality Match (40%)
      + Warmth Match (30%)
      + Weather Suitability (20%)
      + Favorites Bonus (10%)
```

### 3. ViewModels Layer

**Purpose**: Presentation logic and state management

**Components**:

#### OutfitViewModel
- Manages outfit generation flow
- Coordinates services
- Handles loading states
- Error management

#### WardrobeViewModel
- Wardrobe filtering logic
- Search functionality
- CRUD operations

**State Management**:
- `@Published` for observable state
- `@MainActor` for UI updates
- Async/await for async operations

### 4. Views Layer

**Purpose**: User interface

**Key Views**:

- **HomeView**:
  - Displays outfit suggestions
  - Weather summary
  - Confidence indicators

- **WardrobeView**:
  - Grid layout for items
  - Filters and search
  - Category grouping

- **OutfitDetailView**:
  - Complete outfit breakdown
  - Weather analysis
  - Reasoning explanation

- **AddClothingItemView**:
  - Form for new items
  - Color picker
  - Multi-select for weather

**UI Patterns**:
- Reusable components
- Consistent styling
- Responsive layouts
- Accessibility support

### 5. Utilities Layer

**Extensions**:
- Color hex support
- Date helpers
- Array utilities

**Constants**:
- API endpoints
- Default values
- Thresholds

## Data Flow

### Outfit Generation Flow

```
User Opens App
     ↓
HomeView appears
     ↓
OutfitViewModel.generateSuggestions()
     ↓
┌─────────────────────────────────┐
│  1. Get Location (LocationMgr)  │
│  2. Fetch Weather (WeatherSvc)  │
│  3. Fetch Events (CalendarSvc)  │
│  4. Load Wardrobe (SwiftData)   │
└────────────┬────────────────────┘
             ↓
OutfitSuggestionEngine.generateSuggestions()
             ↓
┌────────────────────────────────┐
│ Algorithm:                     │
│ - Filter by weather            │
│ - Score items                  │
│ - Generate combinations        │
│ - Calculate confidence         │
│ - Create reasoning             │
└──────────┬─────────────────────┘
           ↓
    [OutfitSuggestion]
           ↓
OutfitViewModel updates @Published suggestions
           ↓
HomeView re-renders with suggestions
```

### Wardrobe Management Flow

```
User Adds Item
     ↓
AddClothingItemView
     ↓
Create ClothingItem
     ↓
ModelContext.insert()
     ↓
SwiftData persists
     ↓
@Query automatically updates
     ↓
WardrobeView re-renders
```

## Concurrency Model

### Async/Await

All async operations use Swift's native async/await:

```swift
Task {
    await weatherService.fetchWeather(for: location)
    await calendarService.fetchTodayEvents()
    // Updates automatically published to UI
}
```

### Main Actor

UI updates guaranteed on main thread:

```swift
@MainActor
class OutfitViewModel: ObservableObject {
    @Published var suggestions: [OutfitSuggestion] = []
}
```

## Data Persistence

### SwiftData

- **Storage**: Local SQLite database
- **Features**:
  - Automatic schema management
  - Type-safe queries
  - Automatic UI updates
  - iCloud sync capable

```swift
@Model
final class ClothingItem: Identifiable {
    var id: UUID
    var name: String
    // ... properties
}
```

### Queries

```swift
@Query private var wardrobeItems: [ClothingItem]
```

Automatically updates views when data changes.

### User Defaults

For app settings:
- API key (should be Keychain in production)
- Unit preferences
- User preferences

## API Integration

### OpenWeatherMap

**Endpoints Used**:
1. Current Weather: `/weather`
2. UV Index: `/uvi`
3. Forecast: `/forecast`

**Request Flow**:
```
App → WeatherService → URLSession → OpenWeatherMap API
                                            ↓
App ← WeatherService ← JSON Response ← API
```

**Rate Limiting**:
- Free tier: 60 calls/minute
- Caching: 15 minutes (not implemented yet)

## Algorithm Details

### Formality Inference

Analyzes event title and notes for keywords:

| Keywords | Formality Level |
|----------|----------------|
| wedding, gala, black tie | Formal |
| presentation, interview | Business Formal |
| meeting, work, office | Business |
| dinner, date, party | Smart Casual |
| gym, workout, errands | Casual |

### Weather Analysis

Multiple factors considered:

1. **Temperature**:
   - > 25°C → Hot
   - < 10°C → Cold

2. **Precipitation**:
   - > 0mm → Rainy/Snowy
   - Requires rain gear

3. **Wind**:
   - > 10 m/s → Windy
   - Requires windproof outerwear

4. **UV Index**:
   - > 6 → High UV
   - Suggests UV protection

### Outfit Scoring

Each clothing item scored based on:

```swift
score = formalityMatch(10)
      + warmthMatch(8)
      + weatherSuitability(2 per match)
      + isFavorite(3)
```

Items with highest scores selected for outfit.

## Error Handling

### Service Errors

```swift
enum WeatherError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case decodingError
}
```

### UI Error States

- Loading states
- Error messages
- Retry mechanisms
- Empty states

## Testing Strategy

### Unit Tests (Recommended)

- Model logic
- Service parsing
- Suggestion algorithm
- Formality inference

### UI Tests (Recommended)

- Navigation flows
- Data entry
- Permission handling

### Integration Tests (Recommended)

- Weather API integration
- Calendar integration
- End-to-end outfit generation

## Performance Considerations

### Optimization Points

1. **Lazy Loading**:
   - Grid views use LazyVGrid

2. **Efficient Queries**:
   - SwiftData predicate filtering

3. **Async Operations**:
   - Non-blocking UI
   - Background fetching

4. **Caching** (Future):
   - Cache weather data
   - Cache outfit suggestions

### Memory Management

- Automatic with Swift/SwiftUI
- @Query manages result sets
- Published properties automatically managed

## Security & Privacy

### API Key Storage

**Current**: UserDefaults (development only)
**Production**: Should use Keychain

### Data Privacy

- All wardrobe data local
- No cloud sync (yet)
- Calendar read-only
- Location approximate only

### Permissions

- Location: When In Use only
- Calendar: Read-only access
- No photo library access
- No network beyond weather API

## Scalability

### Current Limitations

- Single device only
- No user accounts
- No cloud sync
- Limited to local storage

### Future Enhancements

1. **Cloud Sync**:
   - SwiftData + CloudKit
   - Multi-device support

2. **Machine Learning**:
   - User preference learning
   - Outfit history analysis

3. **Social Features**:
   - Outfit sharing
   - Style inspiration

4. **Advanced Weather**:
   - Multi-day forecasting
   - Weather alerts
   - Location tracking

## Dependencies

### Native Frameworks

- SwiftUI (UI)
- SwiftData (Persistence)
- EventKit (Calendar)
- CoreLocation (Location)
- Foundation (Core utilities)

### Third-Party

- None! (Weather API via REST)

## Build Configuration

### Minimum Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Capabilities Needed

- None (all features use standard frameworks)

### Info.plist Requirements

- `NSLocationWhenInUseUsageDescription`
- `NSCalendarsUsageDescription`

## Deployment

### App Store Preparation

1. Add screenshots
2. Prepare description
3. Privacy policy (calendar/location)
4. TestFlight testing
5. App Review submission

### Distribution

- iOS App Store
- TestFlight beta
- Enterprise distribution (optional)

## Code Style

- Swift official style guide
- SwiftLint (recommended)
- Clear naming conventions
- Comprehensive comments

## Maintainability

### Code Organization

- Clear layer separation
- Single responsibility principle
- Reusable components
- Documented complex logic

### Documentation

- README for overview
- SETUP for configuration
- QUICKSTART for new users
- ARCHITECTURE (this doc) for developers

---

**Version**: 1.0.0
**Last Updated**: 2025-11-05
**Maintainer**: Development Team
