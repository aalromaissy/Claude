## 2024-05-18 - SwiftUI Accessibility Requirements
**Learning:** Found several icon-only buttons in the WearWise codebase missing `.accessibilityLabel`. SwiftUI requires explicit `.accessibilityLabel(...)` modifiers on any `Button` where the label consists solely of an icon (e.g., `plus`, `trash`, `heart`) to ensure screen reader accessibility.
**Action:** When working on SwiftUI apps, explicitly scan for and apply `.accessibilityLabel` to any `Button` that only uses `Image(systemName:)` as its content.
