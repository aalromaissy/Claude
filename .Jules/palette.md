## 2025-01-28 - Missing SwiftUI Button Accessibility Labels
**Learning:** In this SwiftUI codebase, `Button` views that use `label:` closures with only an `Image(systemName:)` inherently lack accessible text descriptions, making them difficult or impossible for VoiceOver users to understand.
**Action:** Always add the `.accessibilityLabel("...")` modifier to the `Image` or the `Button` itself whenever implementing an icon-only button to ensure screen reader accessibility.
