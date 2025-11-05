//
//  OutfitViewModel.swift
//  WearWise
//

import Foundation
import CoreLocation
import SwiftData

@MainActor
class OutfitViewModel: ObservableObject {
    @Published var suggestions: [OutfitSuggestion] = []
    @Published var isLoading = false
    @Published var error: String?

    private let weatherService: WeatherService
    private let calendarService: CalendarService
    private let suggestionEngine: OutfitSuggestionEngine
    private let locationManager: LocationManager

    init(
        weatherService: WeatherService = WeatherService(),
        calendarService: CalendarService = CalendarService(),
        suggestionEngine: OutfitSuggestionEngine = OutfitSuggestionEngine(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.calendarService = calendarService
        self.suggestionEngine = suggestionEngine
        self.locationManager = locationManager
    }

    func generateSuggestions(wardrobe: [ClothingItem]) async {
        isLoading = true
        error = nil

        // Get location
        guard let location = locationManager.location else {
            error = "Location not available. Please enable location services."
            isLoading = false
            return
        }

        // Fetch weather
        await weatherService.fetchWeather(for: location)

        guard let weather = weatherService.currentWeather else {
            error = "Unable to fetch weather data."
            isLoading = false
            return
        }

        // Fetch calendar events
        await calendarService.fetchTodayEvents()

        // Generate suggestions
        let newSuggestions = suggestionEngine.generateSuggestions(
            weather: weather,
            events: calendarService.todayEvents,
            wardrobe: wardrobe,
            limit: 3
        )

        suggestions = newSuggestions
        isLoading = false
    }

    func refresh(wardrobe: [ClothingItem]) async {
        await generateSuggestions(wardrobe: wardrobe)
    }
}

// Location Manager for getting user's location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        checkAuthorization()
    }

    func checkAuthorization() {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        checkAuthorization()
    }
}
