## 2024-03-24 - Accessibility improvements for icon-only buttons
**Learning:** In SwiftUI, icon-only buttons need an explicit `.accessibilityLabel(...)` for screen readers. There are several buttons (e.g., refresh, plus, search, favorite, delete) across views that use `Image(systemName:)` as their only content.
**Action:** Add `.accessibilityLabel` to all icon-only buttons in the main views.
