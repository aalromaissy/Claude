## 2026-09-09 - SwiftUI Icon-Only Buttons Accessibility
**Learning:** Icon-only buttons in SwiftUI (e.g., using systemImage like 'plus', 'heart', 'trash') are not automatically accessible to screen readers, making it difficult for visually impaired users to understand their function.
**Action:** Always append the `.accessibilityLabel("Descriptive text")` modifier to the `Button` view when the label consists solely of an icon.
