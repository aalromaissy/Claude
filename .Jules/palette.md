## 2024-05-24 - Missing Accessibility Labels on Icon-Only Buttons
**Learning:** Icon-only buttons in SwiftUI (e.g., using `Image(systemName: ...)`) lack screen reader accessible context by default, creating a poor experience for VoiceOver users.
**Action:** Always add `.accessibilityLabel("...")` to any `Button` where the label consists solely of an icon (e.g., `plus`, `trash`, `heart`) to ensure screen reader accessibility.
