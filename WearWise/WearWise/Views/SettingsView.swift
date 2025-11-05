//
//  SettingsView.swift
//  WearWise
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("weatherAPIKey") private var weatherAPIKey = ""
    @AppStorage("useMetric") private var useMetric = true

    @StateObject private var calendarService = CalendarService()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "cloud.sun.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("WearWise")
                                .font(.headline)
                            Text("Smart Outfit Suggestions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Weather API") {
                    SecureField("OpenWeatherMap API Key", text: $weatherAPIKey)

                    Link(destination: URL(string: "https://openweathermap.org/api")!) {
                        Label("Get API Key", systemImage: "key")
                    }

                    Toggle("Use Metric Units (°C)", isOn: $useMetric)
                }

                Section("Permissions") {
                    HStack {
                        Label("Location", systemImage: "location.fill")
                        Spacer()
                        Text(locationStatusText)
                            .foregroundColor(.secondary)
                    }

                    if locationManager.authorizationStatus != .authorizedWhenInUse &&
                       locationManager.authorizationStatus != .authorizedAlways {
                        Button("Enable Location") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }

                    HStack {
                        Label("Calendar", systemImage: "calendar")
                        Spacer()
                        Text(calendarService.isAuthorized ? "Granted" : "Not Granted")
                            .foregroundColor(.secondary)
                    }

                    if !calendarService.isAuthorized {
                        Button("Enable Calendar") {
                            Task {
                                _ = await calendarService.requestAccess()
                            }
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com/yourusername/wearwise")!) {
                        Label("GitHub", systemImage: "link")
                    }
                }

                Section {
                    Text("WearWise helps you choose the perfect outfit by analyzing weather conditions, your calendar events, and your personal wardrobe.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }

    var locationStatusText: String {
        guard let status = locationManager.authorizationStatus else {
            return "Unknown"
        }

        switch status {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Always"
        case .authorizedWhenInUse:
            return "When In Use"
        @unknown default:
            return "Unknown"
        }
    }
}
