## 2026-08-12 - Add accessibility labels to icon-only buttons
**Learning:** Native iOS apps written in SwiftUI often have icon-only buttons that do not have accessibility labels by default. Screen readers will not be able to accurately describe the button's purpose without an explicit label.
**Action:** Always add `.accessibilityLabel(...)` to `Button` views where the label consists solely of an icon.
