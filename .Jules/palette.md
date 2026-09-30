## 2024-05-19 - Accessibility Labels on Icon-only Buttons
**Learning:** Found multiple instances where system images were used as labels for `Button` views in SwiftUI without explicit accessibility labels (e.g., `Image(systemName: "trash")`). This leaves screen reader users without context for the button's action.
**Action:** Always add `.accessibilityLabel("Descriptive Text")` when creating or modifying icon-only buttons in SwiftUI views to ensure VoiceOver provides meaningful information.
