## 2024-05-24 - Accessibility Labels for Icon-Only Buttons
**Learning:** Adding accessibility labels to icon-only buttons like `arrow.clockwise`, `plus`, `heart`, and `trash` greatly improves VoiceOver navigation for visually impaired users. It is important to dynamically update the label based on the state of the item, like `Remove from favorites` vs `Add to favorites`.
**Action:** Always add `.accessibilityLabel` to any SwiftUI `Button` whose label is purely visual (an `Image`). Use conditionally changing strings for stateful buttons.
