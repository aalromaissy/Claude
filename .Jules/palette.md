## 2026-06-18 - Adding accessibility labels to icon-only buttons in SwiftUI
**Learning:** In native iOS projects using SwiftUI, buttons that only contain icons (like `Image(systemName: "plus")`) do not inherently communicate their purpose to screen readers like VoiceOver. This creates a severe accessibility gap.
**Action:** Always append the `.accessibilityLabel(_:)` modifier with a descriptive string immediately after the `Button` or its label content to ensure screen reader users understand the button's action.
