## 2026-06-05 - SwiftUI Icon-Only Button Accessibility
**Learning:** Icon-only buttons in SwiftUI (using `Image(systemName:)`) lack context for VoiceOver users, similar to missing ARIA labels in web development.
**Action:** Always attach an `.accessibilityLabel(_:)` modifier to SwiftUI buttons that contain only icons to provide descriptive context for screen reader users.
