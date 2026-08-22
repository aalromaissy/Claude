## 2024-05-14 - Screen reader accessibility for icon-only buttons
**Learning:** In SwiftUI, buttons that only contain an `Image` lack screen reader accessibility.
**Action:** Always add `.accessibilityLabel(...)` to icon-only buttons.
