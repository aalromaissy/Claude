## 2026-06-01 - Missing Accessibility Labels on Icon-only Buttons
**Learning:** In SwiftUI, Buttons whose labels consist entirely of an Image icon (e.g., plus, trash, heart) are not accessible to screen readers by default. The system cannot infer a meaningful description from the systemName.
**Action:** Always append `.accessibilityLabel(...)` to the Button or the Image inside it to provide descriptive text for VoiceOver users.
