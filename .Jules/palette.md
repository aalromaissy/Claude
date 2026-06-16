
## 2026-06-16 - Icon-Only Button Accessibility in SwiftUI
**Learning:** In SwiftUI, icon-only buttons (buttons where the label consists solely of an image, like a `plus`, `heart`, or `trash` icon) lack semantic meaning for VoiceOver users, causing them to read out unhelpful descriptions like "button" or the raw SF Symbol name. This creates a significant accessibility barrier.
**Action:** Always append the `.accessibilityLabel(_:)` modifier directly to the `Image` or the `Button` itself when the button's visual representation is purely iconographic, ensuring clear and descriptive text is provided for screen reader users.
