## 2024-05-18 - Missing Accessibility Labels on Icon-only SwiftUI Buttons
**Learning:** Found multiple icon-only buttons (using system images like `plus`, `heart`, `trash`, `arrow.clockwise`) across SwiftUI views lacking `accessibilityLabel` modifiers, violating accessibility guidelines and making the app difficult to use with VoiceOver.
**Action:** When working with SwiftUI `Button` components containing only an `Image(systemName: ...)`, always add an appropriate `.accessibilityLabel(...)` describing the action, incorporating the item's name if the action applies to a specific entity.
