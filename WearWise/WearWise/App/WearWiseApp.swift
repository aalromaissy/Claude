//
//  WearWiseApp.swift
//  WearWise
//

import SwiftUI
import SwiftData

@main
struct WearWiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ClothingItem.self)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var wardrobeItems: [ClothingItem]

    @StateObject private var outfitViewModel = OutfitViewModel()
    @StateObject private var wardrobeViewModel = WardrobeViewModel()
    @StateObject private var calendarService = CalendarService()

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                outfitViewModel: outfitViewModel,
                wardrobeItems: wardrobeItems
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            WardrobeView(
                viewModel: wardrobeViewModel,
                items: wardrobeItems
            )
            .tabItem {
                Label("Wardrobe", systemImage: "tshirt.fill")
            }
            .tag(1)

            SettingsView()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .task {
            // Request calendar access on first launch
            if !calendarService.isAuthorized {
                _ = await calendarService.requestAccess()
            }
        }
    }
}
