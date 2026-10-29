## 2024-05-14 - SwiftUI Icon-Only Buttons Missing Accessibility Labels
**Learning:** Found multiple icon-only buttons in `HomeView.swift` and `WardrobeView.swift` (e.g., refresh, add item, favorite, delete) lacking accessibility labels. Since this is an iOS SwiftUI app, standard ARIA labels aren't applicable. Instead, `.accessibilityLabel("Label")` modifier should be used on icon-only buttons to make them accessible for VoiceOver users.
**Action:** Add `.accessibilityLabel` modifiers to the icon-only buttons identified across the views.
