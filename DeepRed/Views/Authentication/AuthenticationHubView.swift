import SwiftUI

// MARK: - Authentication Hub View

struct AuthenticationHubView: View {
    @State private var showEmailSignUp = false
    @State private var showEmailLogin = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Close Button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.graphite)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    Spacer()
                    
                    // Logo and Title
                    VStack(spacing: DeepRedDesign.Spacing.md) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        
                        Text("Welcome to DeepRed")
                            .font(DeepRedDesign.Typography.displayTitle)
                            .primaryText()
                            .multilineTextAlignment(.center)
                        
                        Text("Create content, find opportunities, showcase your talent")
                            .font(DeepRedDesign.Typography.body)
                            .secondaryText()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DeepRedDesign.Spacing.md)
                    }
                    
                    Spacer()
                    
                    // Authentication Options
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        // Sign in with Apple
                        AuthenticationButton(
                            title: "Sign in with Apple",
                            iconName: "apple.logo",
                            style: .primary
                        ) {
                            // Handle Apple Sign In
                            print("Sign in with Apple tapped")
                        }
                        
                        // Sign in with Google
                        AuthenticationButton(
                            title: "Sign in with Google",
                            iconName: "globe",
                            style: .secondary
                        ) {
                            // Handle Google Sign In
                            print("Sign in with Google tapped")
                        }
                        
                        // Continue with Email
                        AuthenticationButton(
                            title: "Continue with Email",
                            iconName: "envelope",
                            style: .secondary
                        ) {
                            showEmailSignUp = true
                        }
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .fill(DeepRedDesign.Colors.ash)
                                .frame(height: 1)
                            
                            Text("OR")
                                .font(DeepRedDesign.Typography.caption)
                                .secondaryText()
                                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                            
                            Rectangle()
                                .fill(DeepRedDesign.Colors.ash)
                                .frame(height: 1)
                        }
                        .padding(.vertical, DeepRedDesign.Spacing.sm)
                        
                        // Sign In Link
                        Button(action: {
                            showEmailLogin = true
                        }) {
                            Text("Already have an account? Sign in")
                                .font(DeepRedDesign.Typography.body)
                                .accentColor()
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    Spacer()
                    
                    // Terms and Privacy
                    VStack(spacing: DeepRedDesign.Spacing.xs) {
                        Text("By continuing, you agree to our")
                            .font(DeepRedDesign.Typography.caption)
                            .secondaryText()
                        
                        HStack(spacing: 4) {
                            Button("Terms of Service") {
                                // Handle Terms of Service
                            }
                            .font(DeepRedDesign.Typography.caption)
                            .accentColor()
                            
                            Text("and")
                                .font(DeepRedDesign.Typography.caption)
                                .secondaryText()
                            
                            Button("Privacy Policy") {
                                // Handle Privacy Policy
                            }
                            .font(DeepRedDesign.Typography.caption)
                            .accentColor()
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.bottom, DeepRedDesign.Spacing.lg)
                }
            }
        }
        .fullScreenCover(isPresented: $showEmailSignUp) {
            EmailSignUpView()
        }
        .fullScreenCover(isPresented: $showEmailLogin) {
            EmailLoginView()
        }
    }
}

// MARK: - Authentication Button

enum AuthButtonStyle {
    case primary
    case secondary
}

struct AuthenticationButton: View {
    let title: String
    let iconName: String
    let style: AuthButtonStyle
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DeepRedDesign.Spacing.sm) {
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(textColor)
                
                Text(title)
                    .font(DeepRedDesign.Typography.button)
                    .foregroundColor(textColor)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, DeepRedDesign.Spacing.sm)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(DeepRedDesign.CornerRadius.button)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
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
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return DeepRedDesign.Colors.onyx
        case .secondary:
            return DeepRedDesign.Colors.snow
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return DeepRedDesign.Colors.snow
        case .secondary:
            return DeepRedDesign.Colors.onyx
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return DeepRedDesign.Colors.onyx
        case .secondary:
            return DeepRedDesign.Colors.ash
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary:
            return 0
        case .secondary:
            return 1
        }
    }
}

// MARK: - Preview

#Preview("Authentication Hub") {
    AuthenticationHubView()
} 