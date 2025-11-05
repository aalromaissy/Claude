# WearWise - Setup Guide

## Prerequisites

- macOS with Xcode 15.0 or later
- iOS 17.0+ target device or simulator
- OpenWeatherMap API key (free tier available)

## Project Setup in Xcode

Since this project was created as source files, you'll need to create an Xcode project to run it:

### Option 1: Automatic Setup (Recommended)

1. Open Xcode
2. Choose "Create a new Xcode project"
3. Select "iOS" → "App"
4. Configure the project:
   - Product Name: `WearWise`
   - Team: Your development team
   - Organization Identifier: Your identifier (e.g., `com.yourname`)
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `SwiftData`
5. Save the project in the parent directory of the `WearWise` folder
6. Copy all files from `WearWise/WearWise/` to your project's source folder
7. Add the files to your Xcode project (drag and drop into Xcode)
8. Copy `Info.plist` to your project

### Option 2: Using Existing Files

If you prefer to use the existing structure:

1. Create a new iOS App project in Xcode as described above
2. Delete the default files Xcode creates
3. Add all the files from `WearWise/WearWise/` to your project
4. Ensure all files are added to the target

## Configuration

### 1. Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to API keys section
4. Copy your API key

### 2. Configure the App

1. Launch the app in the simulator or on a device
2. Navigate to the Settings tab
3. Paste your OpenWeatherMap API key
4. Grant location permissions when prompted
5. Grant calendar permissions when prompted

### 3. Add Sample Wardrobe Items

To get started quickly:

1. Go to the Wardrobe tab
2. Tap the "+" button
3. Add at least a few items in different categories:
   - Tops (t-shirts, shirts, sweaters)
   - Bottoms (jeans, pants, shorts)
   - Outerwear (jackets, coats)
   - Footwear (shoes, boots)
   - Accessories (umbrellas, sunglasses)

## Project Structure

```
WearWise/
├── App/
│   └── WearWiseApp.swift          # App entry point
├── Models/
│   ├── ClothingItem.swift         # Wardrobe item model
│   ├── WeatherData.swift          # Weather data model
│   ├── CalendarEvent.swift        # Calendar event model
│   └── OutfitSuggestion.swift     # Outfit suggestion model
├── Services/
│   ├── WeatherService.swift       # Weather API integration
│   ├── CalendarService.swift      # Calendar integration
│   └── OutfitSuggestionEngine.swift  # Suggestion algorithm
├── ViewModels/
│   ├── OutfitViewModel.swift      # Home screen logic
│   └── WardrobeViewModel.swift    # Wardrobe management logic
├── Views/
│   ├── HomeView.swift             # Main outfit suggestions view
│   ├── OutfitDetailView.swift     # Detailed outfit view
│   ├── WardrobeView.swift         # Wardrobe management view
│   ├── AddClothingItemView.swift  # Add item form
│   └── SettingsView.swift         # Settings and permissions
└── Utilities/
    ├── Extensions.swift           # Helper extensions
    └── Constants.swift            # App constants
```

## Features

### 🌤️ Comprehensive Weather Analysis
- Real-time temperature and "feels like" temperature
- Precipitation detection (rain/snow)
- Wind speed monitoring
- Humidity levels
- UV index
- Cloud coverage

### 📅 Calendar Integration
- Analyzes today's events
- Infers formality levels from event titles
- Detects outdoor events
- Considers event duration

### 👔 Smart Outfit Suggestions
- Matches formality to calendar events
- Considers all weather conditions
- Suggests appropriate outerwear
- Recommends rain gear when needed
- Includes UV protection for high UV days
- Provides confidence scores
- Explains reasoning for each suggestion

### 🎨 Wardrobe Management
- Categorize items (tops, bottoms, outerwear, footwear, accessories)
- Color coding
- Warmth level ratings
- Formality level ratings
- Weather suitability tags
- Mark favorites
- Search and filter

## Usage

### Daily Workflow

1. **Morning**: Open the app on the Home tab
2. The app automatically:
   - Fetches current weather for your location
   - Checks your calendar for today's events
   - Analyzes your wardrobe
   - Generates 3 outfit suggestions
3. **Review suggestions**: Each includes:
   - Complete outfit breakdown
   - Weather summary
   - Event information (if applicable)
   - Confidence score
   - Reasoning explanation
4. **Tap any suggestion** for detailed view
5. **Refresh** anytime with the refresh button

### Managing Your Wardrobe

1. Go to the Wardrobe tab
2. Add items with the "+" button
3. For each item, specify:
   - Name and category
   - Color
   - Warmth level (very light to very warm)
   - Formality level (casual to formal)
   - Weather suitability (sunny, rainy, cold, etc.)
4. Use filters to browse by category or formality
5. Mark favorites with the heart icon
6. Tap any item for details or to delete

## Permissions

### Location (Required)
- Used to fetch weather data for your area
- Only accessed when using the app
- Can be set to "While Using App"

### Calendar (Optional but Recommended)
- Analyzes events to suggest appropriate formality
- Only reads event titles, times, and locations
- Never modifies your calendar

## Troubleshooting

### "Location not available"
- Ensure Location Services are enabled in Settings
- Grant location permission to WearWise
- Check that you have internet connectivity

### "Unable to fetch weather data"
- Verify your API key is entered correctly in Settings
- Check internet connectivity
- Ensure you haven't exceeded free tier limits (60 calls/minute)

### "No suggestions generated"
- Add more items to your wardrobe
- Ensure items have appropriate weather suitability tags
- Try refreshing with the refresh button

## Technical Details

- **Minimum iOS Version**: 17.0
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Architecture**: MVVM (Model-View-ViewModel)
- **Weather API**: OpenWeatherMap
- **Calendar**: EventKit

## Privacy

- All wardrobe data is stored locally on your device
- Weather API only receives your approximate location
- Calendar data is only read, never modified
- No data is sent to any servers except OpenWeatherMap for weather

## Future Enhancements

Potential features for future versions:
- Photo uploads for clothing items
- Machine learning for better suggestions
- Weather forecasts for planning ahead
- Outfit history tracking
- Style preferences learning
- Social sharing
- Cloud sync across devices

## Credits

Built with:
- SwiftUI
- SwiftData
- EventKit (Calendar)
- CoreLocation
- OpenWeatherMap API

## License

This is a sample project for educational purposes.
