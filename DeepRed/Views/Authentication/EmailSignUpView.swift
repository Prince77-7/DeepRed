import SwiftUI

// MARK: - Email Sign Up View

struct EmailSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var appState = AppStateManager()
    @State private var currentStep = 0
    @State private var showMainApp = false
    
    // Form Data
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var username = ""
    @State private var bio = ""
    @State private var selectedInterests: Set<String> = []
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    
    // Validation States
    @State private var emailValidation: ValidationState = .none
    @State private var passwordValidation: ValidationState = .none
    @State private var confirmPasswordValidation: ValidationState = .none
    @State private var nameValidation: ValidationState = .none
    @State private var usernameValidation: ValidationState = .none
    
    private let totalSteps = 5
    private let interests = [
        "Marketing", "Gaming", "Fashion", "Music", "Art", "Tech",
        "Food", "Travel", "Fitness", "Photography", "Business",
        "Education", "Comedy", "Beauty", "Sports", "DIY"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            if currentStep > 0 {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    currentStep -= 1
                                }
                            } else {
                                dismiss()
                            }
                        }) {
                            Image(systemName: currentStep > 0 ? "chevron.left" : "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.graphite)
                        }
                        
                        Spacer()
                        
                        Text("Step \(currentStep + 1) of \(totalSteps)")
                            .font(DeepRedDesign.Typography.caption)
                            .secondaryText()
                        
                        Spacer()
                        
                        // Skip button (except on last step)
                        if currentStep < totalSteps - 1 {
                            Button("Skip") {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    currentStep += 1
                                }
                            }
                            .font(DeepRedDesign.Typography.body)
                            .accentColor()
                        } else {
                            // Placeholder for alignment
                            Text("")
                                .font(DeepRedDesign.Typography.body)
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    // Progress Bar
                    ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                        .progressViewStyle(LinearProgressViewStyle(tint: DeepRedDesign.Colors.accent))
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                        .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    // Step Content
                    TabView(selection: $currentStep) {
                        // Step 1: Email & Password
                        EmailPasswordStepView(
                            email: $email,
                            password: $password,
                            confirmPassword: $confirmPassword,
                            emailValidation: $emailValidation,
                            passwordValidation: $passwordValidation,
                            confirmPasswordValidation: $confirmPasswordValidation
                        )
                        .tag(0)
                        
                        // Step 2: Profile Info
                        ProfileInfoStepView(
                            fullName: $fullName,
                            username: $username,
                            nameValidation: $nameValidation,
                            usernameValidation: $usernameValidation
                        )
                        .tag(1)
                        
                        // Step 3: Profile Picture
                        ProfilePictureStepView(
                            profileImage: $profileImage,
                            showImagePicker: $showImagePicker
                        )
                        .tag(2)
                        
                        // Step 4: Bio
                        BioStepView(bio: $bio)
                        .tag(3)
                        
                        // Step 5: Interests
                        InterestsStepView(
                            interests: interests,
                            selectedInterests: $selectedInterests
                        )
                        .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                    
                    // Continue Button
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        PrimaryButton(
                            currentStep == totalSteps - 1 ? "Complete Sign Up" : "Continue",
                            isEnabled: isCurrentStepValid
                        ) {
                            if currentStep == totalSteps - 1 {
                                // Complete sign up
                                completeSignUp()
                            } else {
                                // Go to next step
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    currentStep += 1
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.bottom, DeepRedDesign.Spacing.lg)
                }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainAppView()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
        }
        .onChange(of: email) { _, _ in validateEmail() }
        .onChange(of: password) { _, _ in validatePassword() }
        .onChange(of: confirmPassword) { _, _ in validateConfirmPassword() }
        .onChange(of: fullName) { _, _ in validateName() }
        .onChange(of: username) { _, _ in validateUsername() }
    }
    
    // MARK: - Validation Logic
    
    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 0:
            return emailValidation == .valid && passwordValidation == .valid && confirmPasswordValidation == .valid
        case 1:
            return nameValidation == .valid && usernameValidation == .valid
        case 2:
            return true // Profile picture is optional
        case 3:
            return true // Bio is optional
        case 4:
            return selectedInterests.count >= 3
        default:
            return false
        }
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
        } else if FormValidation.isValidPassword(password) {
            passwordValidation = .valid
        } else {
            passwordValidation = .invalid
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordValidation = .none
        } else if password == confirmPassword {
            confirmPasswordValidation = .valid
        } else {
            confirmPasswordValidation = .invalid
        }
    }
    
    private func validateName() {
        if fullName.isEmpty {
            nameValidation = .none
        } else if FormValidation.isValidName(fullName) {
            nameValidation = .valid
        } else {
            nameValidation = .invalid
        }
    }
    
    private func validateUsername() {
        if username.isEmpty {
            usernameValidation = .none
        } else if FormValidation.isValidUsername(username) {
            usernameValidation = .valid
        } else {
            usernameValidation = .invalid
        }
    }
    
    private func completeSignUp() {
        // Use app state manager for sign up
        if appState.signIn(email: email, password: password) {
            // Success
            HapticFeedback.notification(.success)
            showMainApp = true
        }
    }
}

// MARK: - Step Views

struct EmailPasswordStepView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var emailValidation: ValidationState
    @Binding var passwordValidation: ValidationState
    @Binding var confirmPasswordValidation: ValidationState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                    Text("Create Your Account")
                        .font(DeepRedDesign.Typography.displayTitle)
                        .primaryText()
                    
                    Text("Enter your email and create a secure password")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                }
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
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
                        validationMessage: passwordValidation == .invalid ? "Password must be at least 8 characters" : ""
                    )
                    
                    DeepRedTextField(
                        title: "Confirm Password",
                        placeholder: "Confirm your password",
                        text: $confirmPassword,
                        isSecure: true,
                        validationState: confirmPasswordValidation,
                        validationMessage: confirmPasswordValidation == .invalid ? "Passwords do not match" : ""
                    )
                }
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            .padding(.vertical, DeepRedDesign.Spacing.lg)
        }
    }
}

struct ProfileInfoStepView: View {
    @Binding var fullName: String
    @Binding var username: String
    @Binding var nameValidation: ValidationState
    @Binding var usernameValidation: ValidationState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                    Text("Tell Us About You")
                        .font(DeepRedDesign.Typography.displayTitle)
                        .primaryText()
                    
                    Text("Create your profile so others can find you")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                }
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    DeepRedTextField(
                        title: "Full Name",
                        placeholder: "Enter your full name",
                        text: $fullName,
                        validationState: nameValidation,
                        validationMessage: nameValidation == .invalid ? "Please enter your full name" : ""
                    )
                    
                    DeepRedTextField(
                        title: "Username",
                        placeholder: "Choose a username",
                        text: $username,
                        validationState: usernameValidation,
                        validationMessage: usernameValidation == .invalid ? "Username must be 3-20 characters (letters, numbers, underscore)" : ""
                    )
                }
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            .padding(.vertical, DeepRedDesign.Spacing.lg)
        }
    }
}

struct ProfilePictureStepView: View {
    @Binding var profileImage: UIImage?
    @Binding var showImagePicker: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                    Text("Add Profile Picture")
                        .font(DeepRedDesign.Typography.displayTitle)
                        .primaryText()
                    
                    Text("Help others recognize you with a profile picture")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                }
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    // Profile Picture Preview
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(DeepRedDesign.Colors.ash)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "camera")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.graphite)
                                )
                        }
                    }
                    
                    SecondaryButton("Choose Photo") {
                        showImagePicker = true
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            .padding(.vertical, DeepRedDesign.Spacing.lg)
        }
    }
}

struct BioStepView: View {
    @Binding var bio: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                    Text("Write Your Bio")
                        .font(DeepRedDesign.Typography.displayTitle)
                        .primaryText()
                    
                    Text("Tell others about yourself and what you do")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                }
                
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    Text("Bio")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .primaryText()
                    
                    TextField("Tell us about yourself...", text: $bio, axis: .vertical)
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(DeepRedDesign.Colors.onyx)
                        .tint(DeepRedDesign.Colors.accent)
                        .padding(.horizontal, DeepRedDesign.Spacing.sm)
                        .padding(.vertical, DeepRedDesign.Spacing.sm)
                        .frame(minHeight: 100, alignment: .top)
                        .background(DeepRedDesign.Colors.snow)
                        .overlay(
                            RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                                .stroke(DeepRedDesign.Colors.ash, lineWidth: 1)
                        )
                        .cornerRadius(DeepRedDesign.CornerRadius.button)
                }
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            .padding(.vertical, DeepRedDesign.Spacing.lg)
        }
    }
}

struct InterestsStepView: View {
    let interests: [String]
    @Binding var selectedInterests: Set<String>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                    Text("Choose Your Interests")
                        .font(DeepRedDesign.Typography.displayTitle)
                        .primaryText()
                    
                    Text("Select at least 3 interests to personalize your feed")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                }
                
                TagSelectionView(
                    title: "Interests",
                    tags: interests,
                    selectedTags: $selectedInterests,
                    minimumSelection: 3
                )
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            .padding(.vertical, DeepRedDesign.Spacing.lg)
        }
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Preview

#Preview("Email Sign Up") {
    EmailSignUpView()
} 