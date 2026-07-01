## 2024-07-26 - SwiftUI Icon-Only Buttons Accessibility
**Learning:** Found multiple instances of icon-only Buttons (e.g., plus, heart, trash, refresh) in SwiftUI views without `.accessibilityLabel` modifiers, rendering them unreadable by VoiceOver.
**Action:** Always add `.accessibilityLabel` to any SwiftUI Button whose label consists solely of an Image to ensure screen reader accessibility.
