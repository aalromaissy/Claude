//
//  WeatherService.swift
//  WearWise
//

import Foundation
import CoreLocation

class WeatherService: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var isLoading = false
    @Published var error: Error?

    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"

    init(apiKey: String = "") {
        // In production, use a secure method to store API key
        // For now, users will need to add their own OpenWeatherMap API key
        self.apiKey = apiKey
    }

    func fetchWeather(for location: CLLocation) async {
        await MainActor.run {
            isLoading = true
            error = nil
        }

        guard !apiKey.isEmpty else {
            await MainActor.run {
                isLoading = false
                error = WeatherError.missingAPIKey
            }
            return
        }

        do {
            let weather = try await fetchCurrentWeather(latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude)
            let uvIndex = try await fetchUVIndex(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude)

            await MainActor.run {
                var weatherWithUV = weather
                self.currentWeather = WeatherData(
                    temperature: weather.temperature,
                    feelsLike: weather.feelsLike,
                    condition: weather.condition,
                    description: weather.description,
                    humidity: weather.humidity,
                    windSpeed: weather.windSpeed,
                    precipitation: weather.precipitation,
                    uvIndex: uvIndex,
                    cloudCover: weather.cloudCover,
                    timestamp: weather.timestamp
                )
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }

    private func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }

        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(OpenWeatherResponse.self, from: data)
        return weatherResponse.toWeatherData()
    }

    private func fetchUVIndex(latitude: Double, longitude: Double) async throws -> Double {
        // OpenWeatherMap UV Index API
        let urlString = "\(baseURL)/uvi?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            return 0
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return 0
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let value = json["value"] as? Double {
                return value
            }
        } catch {
            // Return default value if UV index fetch fails
            return 0
        }

        return 0
    }

    // Get weather forecast for planning ahead
    func fetchForecast(for location: CLLocation, days: Int = 5) async throws -> [WeatherData] {
        guard !apiKey.isEmpty else {
            throw WeatherError.missingAPIKey
        }

        let urlString = "\(baseURL)/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&cnt=\(days * 8)" // 8 forecasts per day (3-hour intervals)

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }

        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)

        return forecastResponse.list.map { $0.toWeatherData() }
    }
}

enum WeatherError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Weather API key is missing. Please add your OpenWeatherMap API key in Settings."
        case .invalidURL:
            return "Invalid weather service URL"
        case .invalidResponse:
            return "Invalid response from weather service"
        case .decodingError:
            return "Failed to decode weather data"
        }
    }
}

// Forecast response model
struct ForecastResponse: Codable {
    let list: [OpenWeatherResponse]
}
