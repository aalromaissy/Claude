## 2026-05-29 - VoiceOver Support for Icon-Only Buttons
**Learning:** Icon-only buttons in SwiftUI (e.g., using Image(systemName:)) do not automatically announce their purpose to VoiceOver. Without an explicit accessibility label, screen readers either announce the symbol name (which may not make sense to the user) or just 'button'.
**Action:** Consistently apply .accessibilityLabel() modifiers to all Button views that only contain an Image label to provide a clear, descriptive action name for screen reader users.
