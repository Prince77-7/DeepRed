import SwiftUI

// MARK: - Form Input Components

struct DeepRedTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let validationState: ValidationState
    let validationMessage: String
    
    @State private var isSecureTextVisible = false
    @FocusState private var isFocused: Bool
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        validationState: ValidationState = .none,
        validationMessage: String = ""
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.validationState = validationState
        self.validationMessage = validationMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
            // Title
            Text(title)
                .font(DeepRedDesign.Typography.bodyBold)
                .primaryText()
            
            // Input Field
            HStack {
                if isSecure && !isSecureTextVisible {
                    SecureField(placeholder, text: $text)
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(DeepRedDesign.Colors.onyx)
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(DeepRedDesign.Colors.onyx)
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                }
                
                if isSecure {
                    Button(action: {
                        isSecureTextVisible.toggle()
                    }) {
                        Image(systemName: isSecureTextVisible ? "eye.slash" : "eye")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                    }
                }
            }
            .padding(.horizontal, DeepRedDesign.Spacing.sm)
            .padding(.vertical, DeepRedDesign.Spacing.sm)
            .background(DeepRedDesign.Colors.snow)
            .tint(DeepRedDesign.Colors.accent) // Text cursor color
            .overlay(
                RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(DeepRedDesign.CornerRadius.button)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: validationState)
            
            // Validation Message
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .font(DeepRedDesign.Typography.caption)
                    .foregroundColor(validationColor)
                    .transition(.opacity)
            }
        }
    }
    
    private var borderColor: Color {
        if isFocused {
            return DeepRedDesign.Colors.accent
        }
        
        switch validationState {
        case .none:
            return DeepRedDesign.Colors.ash
        case .valid:
            return DeepRedDesign.Colors.success
        case .invalid:
            return DeepRedDesign.Colors.error
        }
    }
    
    private var borderWidth: CGFloat {
        isFocused ? 2 : 1
    }
    
    private var validationColor: Color {
        switch validationState {
        case .none:
            return DeepRedDesign.Colors.graphite
        case .valid:
            return DeepRedDesign.Colors.success
        case .invalid:
            return DeepRedDesign.Colors.error
        }
    }
}

// MARK: - Validation State

enum ValidationState {
    case none
    case valid
    case invalid
}

// MARK: - Form Validation Helper

struct FormValidation {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    
    static func isValidName(_ name: String) -> Bool {
        return name.trimmingCharacters(in: .whitespaces).count >= 2
    }
}

// MARK: - Tag Selection Component

struct TagSelectionView: View {
    let title: String
    let tags: [String]
    @Binding var selectedTags: Set<String>
    let minimumSelection: Int
    let maximumSelection: Int
    
    init(
        title: String,
        tags: [String],
        selectedTags: Binding<Set<String>>,
        minimumSelection: Int = 0,
        maximumSelection: Int = Int.max
    ) {
        self.title = title
        self.tags = tags
        self._selectedTags = selectedTags
        self.minimumSelection = minimumSelection
        self.maximumSelection = maximumSelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
            Text(title)
                .font(DeepRedDesign.Typography.bodyBold)
                .primaryText()
            
            if minimumSelection > 0 {
                Text("Select at least \(minimumSelection) interest\(minimumSelection > 1 ? "s" : "")")
                    .font(DeepRedDesign.Typography.caption)
                    .secondaryText()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: DeepRedDesign.Spacing.xs),
                GridItem(.flexible(), spacing: DeepRedDesign.Spacing.xs),
                GridItem(.flexible(), spacing: DeepRedDesign.Spacing.xs)
            ], spacing: DeepRedDesign.Spacing.xs) {
                ForEach(tags, id: \.self) { tag in
                    TagButton(
                        title: tag,
                        isSelected: selectedTags.contains(tag)
                    ) {
                        if selectedTags.contains(tag) {
                            selectedTags.remove(tag)
                        } else if selectedTags.count < maximumSelection {
                            selectedTags.insert(tag)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Tag Button

struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.selection()
            action()
        }) {
            Text(title)
                .font(DeepRedDesign.Typography.micro)
                .foregroundColor(isSelected ? DeepRedDesign.Colors.snow : DeepRedDesign.Colors.onyx)
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.vertical, DeepRedDesign.Spacing.xs)
                .background(isSelected ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.snow)
                .overlay(
                    RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                        .stroke(
                            isSelected ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.ash,
                            lineWidth: 1
                        )
                )
                .cornerRadius(DeepRedDesign.CornerRadius.button)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

// MARK: - Preview

#Preview("Form Components") {
    ScrollView {
        VStack(spacing: DeepRedDesign.Spacing.md) {
            DeepRedTextField(
                title: "Email",
                placeholder: "Enter your email",
                text: .constant(""),
                keyboardType: .emailAddress,
                validationState: .none,
                validationMessage: ""
            )
            
            DeepRedTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: .constant(""),
                isSecure: true,
                validationState: .invalid,
                validationMessage: "Password must be at least 8 characters"
            )
            
            TagSelectionView(
                title: "Select Your Interests",
                tags: ["Marketing", "Gaming", "Fashion", "Music", "Art", "Tech"],
                selectedTags: .constant(Set(["Marketing", "Gaming"])),
                minimumSelection: 3
            )
        }
        .padding()
    }
    .primaryBackground()
} 