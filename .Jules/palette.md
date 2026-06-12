## 2026-06-12 - Missing Accessibility Labels on Icon-Only Buttons
**Learning:** In SwiftUI, buttons constructed using only an `Image(systemName:)` for their label do not provide an implicit accessibility label for screen readers. This makes critical actions (like refresh, add, favorite, delete) opaque to users relying on assistive technologies.
**Action:** Always append the `.accessibilityLabel(_:)` modifier to any `Button` whose label is an icon to explicitly define its purpose for screen readers.
