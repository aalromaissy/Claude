//
//  CalendarService.swift
//  WearWise
//

import Foundation
import EventKit

class CalendarService: ObservableObject {
    @Published var todayEvents: [CalendarEvent] = []
    @Published var isAuthorized = false
    @Published var isLoading = false

    private let eventStore = EKEventStore()

    init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        isAuthorized = status == .authorized
    }

    func requestAccess() async -> Bool {
        do {
            let granted = try await eventStore.requestAccess(to: .event)
            await MainActor.run {
                isAuthorized = granted
            }
            return granted
        } catch {
            print("Calendar access error: \(error.localizedDescription)")
            await MainActor.run {
                isAuthorized = false
            }
            return false
        }
    }

    func fetchTodayEvents() async {
        guard isAuthorized else {
            print("Calendar access not authorized")
            return
        }

        await MainActor.run {
            isLoading = true
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = eventStore.predicateForEvents(withStart: startOfDay,
                                                      end: endOfDay,
                                                      calendars: nil)

        let events = eventStore.events(matching: predicate)
            .map { CalendarEvent(from: $0) }
            .sorted { $0.startDate < $1.startDate }

        await MainActor.run {
            todayEvents = events
            isLoading = false
        }
    }

    func fetchEvents(for date: Date) async -> [CalendarEvent] {
        guard isAuthorized else {
            return []
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = eventStore.predicateForEvents(withStart: startOfDay,
                                                      end: endOfDay,
                                                      calendars: nil)

        return eventStore.events(matching: predicate)
            .map { CalendarEvent(from: $0) }
            .sorted { $0.startDate < $1.startDate }
    }

    func getMostFormalEvent(from events: [CalendarEvent]) -> CalendarEvent? {
        return events.max { $0.inferredFormality < $1.inferredFormality }
    }

    func getNextEvent() -> CalendarEvent? {
        let now = Date()
        return todayEvents.first { $0.startDate > now }
    }

    func getCurrentEvent() -> CalendarEvent? {
        let now = Date()
        return todayEvents.first { $0.startDate <= now && $0.endDate > now }
    }
}
