import SwiftUI

// MARK: - DeepRed Design System

struct DeepRedDesign {
    
    // MARK: - Colors
    struct Colors {
        // Primary Brand Colors (60/30/10 Rule)
        static let deepRed = Color(hex: "#850101")     // 10% - Primary CTAs, active states
        static let onyx = Color(hex: "#1C1C1E")        // 30% - Primary text, headlines
        static let snow = Color(hex: "#FFFFFF")        // 60% - Background, cards, sheets
        
        // Secondary Colors
        static let graphite = Color(hex: "#8E8E93")    // Secondary text, captions
        static let ash = Color(hex: "#F2F2F7")         // Separators, secondary backgrounds
        
        // System Colors
        static let success = Color(hex: "#34C759")     // Success states
        static let warning = Color(hex: "#FF9500")     // Warnings
        static let error = Color(hex: "#FF3B30")       // Error states
        
        // Semantic Colors
        static let primaryBackground = snow
        static let secondaryBackground = ash
        static let primaryText = onyx
        static let secondaryText = graphite
        static let accent = deepRed
    }
    
    // MARK: - Typography
    struct Typography {
        // Display Title: Bold, 32pt, 40pt line height
        static let displayTitle = Font.system(size: 32, weight: .bold, design: .default)
        
        // Title 1: Bold, 24pt, 32pt line height
        static let title1 = Font.system(size: 24, weight: .bold, design: .default)
        
        // Title 2: Semibold, 20pt, 24pt line height
        static let title2 = Font.system(size: 20, weight: .semibold, design: .default)
        
        // Body: Regular, 16pt, 24pt line height
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        
        // Body Bold: Bold, 16pt, 24pt line height
        static let bodyBold = Font.system(size: 16, weight: .bold, design: .default)
        
        // Caption: Regular, 14pt, 24pt line height
        static let caption = Font.system(size: 14, weight: .regular, design: .default)
        
        // Button: Semibold, 16pt
        static let button = Font.system(size: 16, weight: .semibold, design: .default)
        
        // Micro: Semibold, 12pt, 16pt line height
        static let micro = Font.system(size: 12, weight: .semibold, design: .default)
    }
    
    // MARK: - Spacing (8pt Grid System)
    struct Spacing {
        static let unit: CGFloat = 8
        
        static let xs: CGFloat = unit * 1      // 8pt
        static let sm: CGFloat = unit * 2      // 16pt
        static let md: CGFloat = unit * 3      // 24pt
        static let lg: CGFloat = unit * 4      // 32pt
        static let xl: CGFloat = unit * 5      // 40pt
        static let xxl: CGFloat = unit * 6     // 48pt
        
        // Common margins
        static let screenMargin: CGFloat = sm  // 16pt
        static let sectionMargin: CGFloat = md // 24pt
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let button: CGFloat = 12
        static let card: CGFloat = 16
        static let modal: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let card = Color.black.opacity(0.08)
        static let cardOffset = CGSize(width: 0, height: 4)
        static let cardRadius: CGFloat = 16
        
        static let tabBar = Color.black.opacity(0.12)
        static let tabBarOffset = CGSize(width: 0, height: 2)
        static let tabBarRadius: CGFloat = 8
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions for Design System
extension View {
    // Apply design system colors
    func primaryBackground() -> some View {
        self.background(DeepRedDesign.Colors.primaryBackground)
    }
    
    func secondaryBackground() -> some View {
        self.background(DeepRedDesign.Colors.secondaryBackground)
    }
    
    func primaryText() -> some View {
        self.foregroundColor(DeepRedDesign.Colors.primaryText)
    }
    
    func secondaryText() -> some View {
        self.foregroundColor(DeepRedDesign.Colors.secondaryText)
    }
    
    func accentColor() -> some View {
        self.foregroundColor(DeepRedDesign.Colors.accent)
    }
    
    // Apply standard card styling
    func cardStyle() -> some View {
        self
            .background(DeepRedDesign.Colors.snow)
            .cornerRadius(DeepRedDesign.CornerRadius.card)
            .shadow(
                color: DeepRedDesign.Shadow.card,
                radius: DeepRedDesign.Shadow.cardRadius,
                x: DeepRedDesign.Shadow.cardOffset.width,
                y: DeepRedDesign.Shadow.cardOffset.height
            )
    }
    
    // Apply standard screen padding
    func screenPadding() -> some View {
        self.padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
}

// MARK: - Keyboard Dismissal
extension View {
    /// Adds a tap gesture to dismiss the keyboard when tapping anywhere on the view
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }
    
    /// Adds keyboard dismissal to a container view without interfering with child interactions
    func dismissKeyboardOnBackgroundTap() -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    hideKeyboard()
                }
        )
    }
    
    /// Hide keyboard helper function
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
} 