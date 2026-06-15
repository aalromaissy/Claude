## 2024-05-24 - Missing Accessibility Labels on Icon-Only Buttons
**Learning:** Found a pattern across the app where SwiftUI `Button`s with only an `Image` for a label (e.g., `plus`, `heart`, `trash`, `arrow.clockwise`) lacked `.accessibilityLabel`s, making them invisible or unclear to screen readers.
**Action:** Always verify icon-only buttons in SwiftUI have `.accessibilityLabel("Descriptive text")` added so VoiceOver users understand the button's purpose.
