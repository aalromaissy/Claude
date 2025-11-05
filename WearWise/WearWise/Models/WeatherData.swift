//
//  WeatherData.swift
//  WearWise
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double // Celsius
    let feelsLike: Double
    let condition: String
    let description: String
    let humidity: Int // Percentage
    let windSpeed: Double // m/s
    let precipitation: Double // mm
    let uvIndex: Double
    let cloudCover: Int // Percentage
    let timestamp: Date

    var temperatureFahrenheit: Double {
        (temperature * 9/5) + 32
    }

    var feelsLikeFahrenheit: Double {
        (feelsLike * 9/5) + 32
    }

    // Derived weather conditions for outfit suggestions
    var weatherConditions: [WeatherCondition] {
        var conditions: [WeatherCondition] = []

        // Temperature-based
        if temperature > 25 {
            conditions.append(.hot)
        } else if temperature < 10 {
            conditions.append(.cold)
        }

        // Precipitation-based
        if precipitation > 0 {
            if temperature < 0 {
                conditions.append(.snowy)
            } else {
                conditions.append(.rainy)
            }
        }

        // Wind-based
        if windSpeed > 10 {
            conditions.append(.windy)
        }

        // Cloud cover
        if cloudCover < 20 {
            conditions.append(.sunny)
        } else if cloudCover > 70 {
            conditions.append(.cloudy)
        }

        // Humidity
        if humidity > 70 {
            conditions.append(.humid)
        }

        return conditions
    }

    var warmthRequired: WarmthLevel {
        if temperature < 0 {
            return .veryWarm
        } else if temperature < 10 {
            return .warm
        } else if temperature < 18 {
            return .medium
        } else if temperature < 25 {
            return .light
        } else {
            return .veryLight
        }
    }

    var needsOuterwear: Bool {
        temperature < 18 || precipitation > 0 || windSpeed > 8
    }

    var needsRainGear: Bool {
        precipitation > 0.5
    }

    var needsUVProtection: Bool {
        uvIndex > 6
    }
}

// OpenWeatherMap API Response Models
struct OpenWeatherResponse: Codable {
    let main: MainWeather
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: TimeInterval

    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }

    struct Weather: Codable {
        let main: String
        let description: String
    }

    struct Wind: Codable {
        let speed: Double
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Rain: Codable {
        let oneHour: Double?

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }

    struct Snow: Codable {
        let oneHour: Double?

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }

    func toWeatherData(uvIndex: Double = 0) -> WeatherData {
        WeatherData(
            temperature: main.temp,
            feelsLike: main.feelsLike,
            condition: weather.first?.main ?? "Unknown",
            description: weather.first?.description ?? "Unknown",
            humidity: main.humidity,
            windSpeed: wind.speed,
            precipitation: (rain?.oneHour ?? 0) + (snow?.oneHour ?? 0),
            uvIndex: uvIndex,
            cloudCover: clouds.all,
            timestamp: Date(timeIntervalSince1970: dt)
        )
    }
}
