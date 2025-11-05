//
//  CalendarEvent.swift
//  WearWise
//

import Foundation
import EventKit

struct CalendarEvent: Identifiable {
    let id: String
    let title: String
    let location: String?
    let startDate: Date
    let endDate: Date
    let notes: String?

    var inferredFormality: FormalityLevel {
        let titleLower = title.lowercased()
        let notesLower = (notes ?? "").lowercased()
        let combined = titleLower + " " + notesLower

        // Formal event keywords
        if combined.contains("wedding") || combined.contains("gala") ||
           combined.contains("black tie") || combined.contains("formal dinner") {
            return .formal
        }

        // Business formal keywords
        if combined.contains("presentation") || combined.contains("board meeting") ||
           combined.contains("client meeting") || combined.contains("interview") ||
           combined.contains("conference") {
            return .businessFormal
        }

        // Business casual keywords
        if combined.contains("meeting") || combined.contains("work") ||
           combined.contains("office") || combined.contains("business") {
            return .business
        }

        // Smart casual keywords
        if combined.contains("dinner") || combined.contains("date") ||
           combined.contains("party") || combined.contains("brunch") {
            return .smartCasual
        }

        // Default to casual for workouts, errands, etc.
        if combined.contains("gym") || combined.contains("workout") ||
           combined.contains("run") || combined.contains("exercise") ||
           combined.contains("errands") {
            return .casual
        }

        // Default to smart casual for unknown events
        return .smartCasual
    }

    var isOutdoorEvent: Bool {
        let titleLower = title.lowercased()
        let notesLower = (notes ?? "").lowercased()
        let locationLower = (location ?? "").lowercased()
        let combined = titleLower + " " + notesLower + " " + locationLower

        return combined.contains("outdoor") || combined.contains("park") ||
               combined.contains("garden") || combined.contains("beach") ||
               combined.contains("hike") || combined.contains("picnic")
    }

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    var isAllDay: Bool {
        duration >= 23 * 3600 // 23+ hours
    }

    init(from ekEvent: EKEvent) {
        self.id = ekEvent.eventIdentifier
        self.title = ekEvent.title ?? "Untitled Event"
        self.location = ekEvent.location
        self.startDate = ekEvent.startDate
        self.endDate = ekEvent.endDate
        self.notes = ekEvent.notes
    }

    init(id: String, title: String, location: String?, startDate: Date, endDate: Date, notes: String?) {
        self.id = id
        self.title = title
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
    }
}
