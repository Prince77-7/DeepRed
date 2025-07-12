import SwiftUI

// MARK: - Button Components

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DeepRedDesign.Typography.button)
                .foregroundColor(isEnabled ? DeepRedDesign.Colors.snow : DeepRedDesign.Colors.graphite)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    isEnabled ? DeepRedDesign.Colors.deepRed : DeepRedDesign.Colors.ash
                )
                .cornerRadius(DeepRedDesign.CornerRadius.button)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        HapticFeedback.impact(.light)
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DeepRedDesign.Typography.button)
                .foregroundColor(isEnabled ? DeepRedDesign.Colors.onyx : DeepRedDesign.Colors.graphite)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                        .stroke(
                            isEnabled ? DeepRedDesign.Colors.onyx : DeepRedDesign.Colors.graphite,
                            lineWidth: 1
                        )
                        .background(
                            isEnabled ? DeepRedDesign.Colors.snow : DeepRedDesign.Colors.ash
                        )
                        .cornerRadius(DeepRedDesign.CornerRadius.button)
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        HapticFeedback.impact(.light)
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

struct TertiaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    @State private var isPressed = false
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DeepRedDesign.Typography.button)
                .foregroundColor(isEnabled ? DeepRedDesign.Colors.onyx : DeepRedDesign.Colors.graphite)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.clear)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .disabled(!isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        HapticFeedback.impact(.light)
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

// MARK: - Record Button (Special Tab Bar Button)

struct RecordButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(DeepRedDesign.Colors.deepRed)
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: DeepRedDesign.Shadow.tabBar,
                        radius: DeepRedDesign.Shadow.tabBarRadius,
                        x: DeepRedDesign.Shadow.tabBarOffset.width,
                        y: DeepRedDesign.Shadow.tabBarOffset.height
                    )
                
                Image(systemName: "record.circle.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.snow)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        HapticFeedback.impact(.medium)
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

// MARK: - Floating Record Button

struct FloatingRecordButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.impact(.heavy)
            action()
        }) {
            ZStack {
                // Shadow background
                Circle()
                    .fill(DeepRedDesign.Colors.accent)
                    .frame(width: 64, height: 64)
                    .shadow(
                        color: DeepRedDesign.Colors.accent.opacity(0.3),
                        radius: 16,
                        x: 0,
                        y: 8
                    )
                
                // Record icon
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(DeepRedDesign.Colors.snow)
                    .rotationEffect(.degrees(isPressed ? 45 : 0))
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Haptic Feedback Helper

struct HapticFeedback {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

// MARK: - Preview

#Preview("Buttons") {
    VStack(spacing: DeepRedDesign.Spacing.md) {
        PrimaryButton("Primary Button") {
            print("Primary button tapped")
        }
        
        SecondaryButton("Secondary Button") {
            print("Secondary button tapped")
        }
        
        TertiaryButton("Tertiary Button") {
            print("Tertiary button tapped")
        }
        
        HStack {
            PrimaryButton("Disabled", isEnabled: false) {
                print("Disabled button tapped")
            }
            
            RecordButton {
                print("Record button tapped")
            }
        }
    }
    .padding()
    .primaryBackground()
} 