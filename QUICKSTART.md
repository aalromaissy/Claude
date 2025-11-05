# WearWise - Quick Start Guide

Get up and running with WearWise in 5 minutes!

## Step 1: Create Xcode Project (2 minutes)

1. Open Xcode
2. File → New → Project
3. Select iOS → App
4. Configure:
   - Product Name: **WearWise**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **SwiftData**
   - ✓ Include Tests (optional)
5. Click Next and save

## Step 2: Add Source Files (1 minute)

1. In Finder, navigate to the `WearWise/WearWise/` folder
2. Drag the following folders into your Xcode project:
   - App
   - Models
   - Services
   - ViewModels
   - Views
   - Utilities
3. When prompted, check "Copy items if needed"
4. Ensure files are added to the WearWise target

## Step 3: Configure Info.plist (30 seconds)

Add these privacy descriptions to your Info.plist:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>WearWise needs your location to provide accurate weather-based outfit suggestions.</string>

<key>NSCalendarsUsageDescription</key>
<string>WearWise needs access to your calendar to suggest outfits appropriate for your events.</string>
```

Or use the provided `Info.plist` file.

## Step 4: Get API Key (1 minute)

1. Visit https://openweathermap.org/appid
2. Sign up (free)
3. Generate API key
4. Copy the key (you'll need it in Step 6)

## Step 5: Build and Run (30 seconds)

1. Select a simulator or device (iOS 17.0+)
2. Press Cmd+R or click the Play button
3. Wait for the build to complete

## Step 6: First Launch Setup (1 minute)

When the app launches:

1. **Grant Permissions**:
   - Tap "Allow" for Location
   - Tap "Allow" for Calendar

2. **Add API Key**:
   - Go to Settings tab (gear icon)
   - Paste your OpenWeatherMap API key
   - The key is saved automatically

3. **Add Some Clothes**:
   - Go to Wardrobe tab
   - Tap "+" button
   - Add at least:
     - 1 top (e.g., "Blue T-Shirt", Casual, Light)
     - 1 bottom (e.g., "Black Jeans", Casual, Medium)
     - 1 outerwear (e.g., "Rain Jacket", Casual, Warm, Rainy)
     - 1 footwear (e.g., "Sneakers", Casual, Light)

## Step 7: Get Your First Suggestion!

1. Go back to Home tab
2. Tap "Generate Suggestions"
3. View your personalized outfit suggestions!

## That's It! 🎉

You now have a working outfit suggestion app that considers:
- ✓ Real weather conditions
- ✓ Your calendar events
- ✓ Your actual wardrobe

## Next Steps

- Add more clothing items to get better suggestions
- Create calendar events to test formality matching
- Explore the outfit detail view for reasoning
- Mark favorite items with the heart icon
- Try the search and filter features

## Common Issues

**"Location not available"**
- Go to iOS Settings → Privacy → Location Services
- Enable for WearWise

**"Weather API error"**
- Check your API key in Settings
- Verify internet connection
- Free tier limit: 60 calls/minute

**"No suggestions"**
- Add more wardrobe items
- Ensure items have weather suitability tags
- Try the refresh button

## Tips for Best Results

1. **Be specific with colors**: Use actual color names
2. **Tag weather suitability**: Select appropriate weather conditions
3. **Vary formality levels**: Add both casual and formal items
4. **Include accessories**: Umbrellas, sunglasses make suggestions smarter
5. **Add calendar events**: The app suggests outfits based on your schedule

## Sample Wardrobe

For quick testing, add these items:

| Name | Category | Color | Warmth | Formality | Weather |
|------|----------|-------|---------|-----------|---------|
| White T-Shirt | Top | White | Very Light | Casual | Sunny, Hot |
| Black Dress Shirt | Top | Black | Light | Business | - |
| Blue Jeans | Bottom | Blue | Medium | Casual | - |
| Dress Pants | Bottom | Black | Medium | Business Formal | - |
| Rain Jacket | Outerwear | Navy | Warm | Casual | Rainy, Windy |
| Blazer | Outerwear | Black | Medium | Business | - |
| Sneakers | Footwear | White | Light | Casual | - |
| Dress Shoes | Footwear | Black | Light | Business | - |
| Umbrella | Accessory | Black | Very Light | Casual | Rainy |
| Sunglasses | Accessory | Black | Very Light | Casual | Sunny |

Enjoy WearWise! 👕🌤️
