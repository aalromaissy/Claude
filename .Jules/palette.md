## 2024-05-15 - Missing Accessibility Labels on Icon-Only Buttons
**Learning:** Icon-only buttons using system images (like "plus", "heart", "trash", "arrow.clockwise") in SwiftUI lack context for screen readers if an `.accessibilityLabel()` is not explicitly added. This app relies heavily on such icons for primary interactions like adding items, marking favorites, or refreshing data.
**Action:** Always add an `.accessibilityLabel()` with descriptive text when implementing or reviewing a SwiftUI `Button` that only contains an `Image`.
