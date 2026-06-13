## 2024-10-24 - Accessibility labels for icon-only buttons in SwiftUI
**Learning:** In iOS SwiftUI applications, icon-only buttons require the `.accessibilityLabel` modifier to be comprehensible to screen reader (VoiceOver) users, similar to `aria-label` on the web.
**Action:** When identifying icon-only buttons (e.g. `Button { ... } label: { Image(systemName: "plus") }`) in SwiftUI codebases, proactively add an `.accessibilityLabel("Descriptive text")`.
