
## 2026-06-09 - SwiftUI Icon-Only Buttons Need Accessibility Labels
**Learning:** In SwiftUI, icon-only `Button` views (where the label consists solely of an `Image`) are not inherently accessible and need explicit labels for screen readers to properly interpret their function.
**Action:** Always append an `.accessibilityLabel("...")` to any `Button` in SwiftUI that only contains an icon.
