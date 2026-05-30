## 2024-06-25 - Essential SwiftUI Accessibility
**Learning:** In SwiftUI, VoiceOver relies heavily on `accessibilityLabel`. Icon-only buttons (like `Image(systemName: "trash")`) are not automatically accessible and will often be read out as unclear system names unless explicitly labeled.
**Action:** Always add `.accessibilityLabel("Descriptive text")` to SwiftUI `Button`s that only contain an `Image` or icon.
