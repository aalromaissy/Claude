## 2026-06-03 - Icon-only Buttons Missing Accessibility Labels
**Learning:** In SwiftUI, `Button` elements with only an `Image` as their content do not have descriptive labels for screen readers. This presents an accessibility issue for visually impaired users.
**Action:** Always add an `.accessibilityLabel(_:)` string to any `Button` whose label is exclusively an icon/image.
