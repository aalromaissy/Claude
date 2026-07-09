## 2026-07-09 - Missing Accessibility Labels on SwiftUI Icon Buttons
**Learning:** In SwiftUI, icon-only buttons created with just an Image(systemName:) lack default screen reader labels, causing a poor accessibility experience.
**Action:** Always append .accessibilityLabel("...") to icon-only buttons to ensure clear descriptions for screen reader users.
