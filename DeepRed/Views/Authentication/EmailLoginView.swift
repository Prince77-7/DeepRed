import SwiftUI

// MARK: - Email Login View

struct EmailLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var appState = AppStateManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showMainApp = false
    @State private var showForgotPassword = false
    
    // Validation States
    @State private var emailValidation: ValidationState = .none
    @State private var passwordValidation: ValidationState = .none
    @State private var showLoginError = false
    @State private var loginErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
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
                        
                        VStack(spacing: DeepRedDesign.Spacing.lg) {
                            // Logo and Title
                            VStack(spacing: DeepRedDesign.Spacing.md) {
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                                
                                Text("Welcome Back")
                                    .font(DeepRedDesign.Typography.displayTitle)
                                    .primaryText()
                                    .multilineTextAlignment(.center)
                                
                                Text("Sign in to your account")
                                    .font(DeepRedDesign.Typography.body)
                                    .secondaryText()
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, DeepRedDesign.Spacing.xl)
                            
                            // Login Form
                            VStack(spacing: DeepRedDesign.Spacing.md) {
                                VStack(spacing: DeepRedDesign.Spacing.sm) {
                                    DeepRedTextField(
                                        title: "Email",
                                        placeholder: "Enter your email",
                                        text: $email,
                                        keyboardType: .emailAddress,
                                        validationState: emailValidation,
                                        validationMessage: emailValidation == .invalid ? "Please enter a valid email" : ""
                                    )
                                    
                                    DeepRedTextField(
                                        title: "Password",
                                        placeholder: "Enter your password",
                                        text: $password,
                                        isSecure: true,
                                        validationState: passwordValidation,
                                        validationMessage: passwordValidation == .invalid ? "Password is required" : ""
                                    )
                                }
                                
                                // Forgot Password Link
                                HStack {
                                    Spacer()
                                    
                                    Button("Forgot Password?") {
                                        showForgotPassword = true
                                    }
                                    .font(DeepRedDesign.Typography.body)
                                    .accentColor()
                                }
                                
                                // Error Message
                                if showLoginError {
                                    Text(loginErrorMessage)
                                        .font(DeepRedDesign.Typography.caption)
                                        .foregroundColor(DeepRedDesign.Colors.error)
                                        .multilineTextAlignment(.center)
                                        .transition(.opacity)
                                }
                                
                                // Sign In Button
                                PrimaryButton(
                                    "Sign In",
                                    isEnabled: isFormValid
                                ) {
                                    signIn()
                                }
                                .padding(.top, DeepRedDesign.Spacing.sm)
                            }
                            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                            
                            // Sign Up Link
                            VStack(spacing: DeepRedDesign.Spacing.sm) {
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
                                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                                
                                Button("Don't have an account? Sign up") {
                                    dismiss()
                                }
                                .font(DeepRedDesign.Typography.body)
                                .accentColor()
                            }
                            .padding(.bottom, DeepRedDesign.Spacing.lg)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainAppView()
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
        .onChange(of: email) { _, _ in validateEmail() }
        .onChange(of: password) { _, _ in validatePassword() }
    }
    
    // MARK: - Validation & Actions
    
    private var isFormValid: Bool {
        return emailValidation == .valid && passwordValidation == .valid
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailValidation = .none
        } else if FormValidation.isValidEmail(email) {
            emailValidation = .valid
        } else {
            emailValidation = .invalid
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordValidation = .none
        } else if password.count > 0 {
            passwordValidation = .valid
        } else {
            passwordValidation = .invalid
        }
    }
    
    private func signIn() {
        // Use app state manager for authentication
        if appState.signIn(email: email, password: password) {
            // Success
            HapticFeedback.notification(.success)
            showMainApp = true
        } else {
            // Error
            HapticFeedback.notification(.error)
            showLoginError = true
            loginErrorMessage = "Invalid email or password. Please try again."
            
            // Hide error after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showLoginError = false
                }
            }
        }
    }
}

// MARK: - Forgot Password View

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var emailValidation: ValidationState = .none
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DeepRedDesign.Spacing.lg) {
                        // Header
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
                        
                        VStack(spacing: DeepRedDesign.Spacing.lg) {
                            // Title and Description
                            VStack(spacing: DeepRedDesign.Spacing.md) {
                                Text("Reset Password")
                                    .font(DeepRedDesign.Typography.displayTitle)
                                    .primaryText()
                                    .multilineTextAlignment(.center)
                                
                                Text("Enter your email address and we'll send you a link to reset your password")
                                    .font(DeepRedDesign.Typography.body)
                                    .secondaryText()
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, DeepRedDesign.Spacing.sm)
                            }
                            .padding(.top, DeepRedDesign.Spacing.xl)
                            
                            if showSuccessMessage {
                                // Success Message
                                VStack(spacing: DeepRedDesign.Spacing.md) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 60, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.success)
                                    
                                    Text("Check Your Email")
                                        .font(DeepRedDesign.Typography.title1)
                                        .primaryText()
                                        .multilineTextAlignment(.center)
                                    
                                    Text("We've sent a password reset link to \(email)")
                                        .font(DeepRedDesign.Typography.body)
                                        .secondaryText()
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, DeepRedDesign.Spacing.sm)
                                    
                                    SecondaryButton("Back to Sign In") {
                                        dismiss()
                                    }
                                    .padding(.top, DeepRedDesign.Spacing.sm)
                                }
                                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                                .transition(.scale.combined(with: .opacity))
                            } else {
                                // Email Input Form
                                VStack(spacing: DeepRedDesign.Spacing.md) {
                                    DeepRedTextField(
                                        title: "Email",
                                        placeholder: "Enter your email",
                                        text: $email,
                                        keyboardType: .emailAddress,
                                        validationState: emailValidation,
                                        validationMessage: emailValidation == .invalid ? "Please enter a valid email" : ""
                                    )
                                    
                                    PrimaryButton(
                                        "Send Reset Link",
                                        isEnabled: emailValidation == .valid
                                    ) {
                                        sendResetLink()
                                    }
                                    .padding(.top, DeepRedDesign.Spacing.sm)
                                }
                                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: email) { _, _ in validateEmail() }
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailValidation = .none
        } else if FormValidation.isValidEmail(email) {
            emailValidation = .valid
        } else {
            emailValidation = .invalid
        }
    }
    
    private func sendResetLink() {
        // Simulate sending reset link
        HapticFeedback.notification(.success)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showSuccessMessage = true
        }
    }
}

// MARK: - Preview

#Preview("Email Login") {
    EmailLoginView()
}

#Preview("Forgot Password") {
    ForgotPasswordView()
} 