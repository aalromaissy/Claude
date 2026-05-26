## 2024-05-26 - SwiftUI `onTapGesture` Accessibility Pattern
**Learning:** Using `.onTapGesture` on custom cards (like `WardrobeItemCard`) makes them inaccessible to screen readers like VoiceOver because they aren't announced as interactive button elements by default.
**Action:** Always add `.accessibilityAddTraits(.isButton)` and an `.accessibilityHint()` when using `.onTapGesture` for interactions, or use a native `Button` with `.buttonStyle(.plain)`.
