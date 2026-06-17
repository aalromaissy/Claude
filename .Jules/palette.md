## 2026-06-17 - Accessibility Label Missing on SwiftUI Icon Buttons
**Learning:** In SwiftUI, icon-only `Button` views (where the label is an `Image(systemName:)`) lack a meaningful default accessibility label, severely degrading the experience for screen reader users.
**Action:** Always append an `.accessibilityLabel(...)` modifier to any icon-only button so that VoiceOver and other assistive technologies can describe its purpose.
