# DeepRed iOS Application

**A high-fidelity iOS application prototype built with SwiftUI 6.2**

DeepRed is a social platform that connects creators with businesses, allowing users to create content, discover opportunities, and showcase their talents. The app features a TikTok-inspired design with a professional marketplace for gig economy services.

## 📱 Features Implemented

### ✅ Core Components
- **Design System**: Complete implementation of the DeepRed design system with colors, typography, spacing (8pt grid), and component library
- **Native Tab Bar**: Five-tab navigation using iOS native TabView with custom styling and elevated record button
- **Reusable Components**: Button variants, form inputs, validation, and interactive elements
- **Haptic Feedback**: Integrated throughout the app for premium user experience

### ✅ Onboarding & Authentication Flow
- **Onboarding Carousel**: Three-page introduction with smooth animations
- **Authentication Hub**: Multiple sign-in options (Apple, Google, Email)
- **Email Sign-Up Flow**: 5-step registration process with validation
  - Email & Password with real-time validation
  - Profile creation (name, username)
  - Profile picture upload
  - Bio writing
  - Interest selection (minimum 3 required)
- **Email Login Flow**: Full login process with error handling
- **Forgot Password**: Password reset flow with email confirmation

### ✅ Main Application Structure
- **Tab-Based Navigation**: Custom tab bar with floating record button
- **Home Feed**: Placeholder for video content feed
- **Services Marketplace**: Placeholder for gig discovery
- **Record/Create**: Video recording interface placeholder
- **Inbox**: Messaging and notifications placeholder
- **Profile**: User profile management placeholder

## 🎨 Design System

### Color Palette
- **DeepRed** (#850101): Primary brand color for CTAs and accents
- **Onyx** (#1C1C1E): Primary text color
- **Snow** (#FFFFFF): Background color
- **Graphite** (#8E8E93): Secondary text
- **Ash** (#F2F2F7): Borders and secondary backgrounds

### Typography
- **Display Title**: 32pt Bold for major headings
- **Title 1**: 24pt Bold for section headers
- **Title 2**: 20pt Semibold for sub-headers
- **Body**: 16pt Regular for primary text
- **Button**: 16pt Semibold for button labels
- **Caption**: 14pt Regular for metadata
- **Micro**: 12pt Semibold for tags

### Spacing & Layout
- **8pt Grid System**: All spacing based on 8pt increments
- **16pt Screen Margins**: Consistent horizontal margins
- **Corner Radius**: 12pt for buttons, 16pt for cards, 24pt for modals

## 🏗️ Architecture

### Component-Driven Development
- **Atomic Design**: Reusable components for consistent UI
- **SwiftUI-First**: Built entirely with SwiftUI 6.2
- **MVVM Pattern**: Clean separation of concerns
- **State Management**: Local state with @State and @Binding

### File Structure
```
DeepRed/
├── DesignSystem.swift           # Core design system & colors
├── Components/
│   ├── Buttons.swift            # Button components
│   ├── CustomTabBar.swift       # Tab bar navigation
│   └── FormComponents.swift     # Form inputs & validation
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Authentication/
│   │   ├── AuthenticationHubView.swift
│   │   ├── EmailSignUpView.swift
│   │   └── EmailLoginView.swift
│   └── MainAppView.swift        # Main app with tab content
├── Assets.xcassets/
│   └── logo.imageset/          # App logo assets
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- **Xcode 15.0+** with SwiftUI 6.2 support
- **iOS 17.0+** deployment target
- **macOS 14.0+** for development

### Installation
1. Clone the repository
2. Open `DeepRed.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run (⌘+R)

### Demo Credentials
For testing the login flow:
- **Email**: `demo@deepred.com`
- **Password**: `password123`

### Demo Features Available
Once logged in, you can experience:
- **Beautiful Home Feed**: Premium video cards with smooth animations
- **Interactive Elements**: Like, bookmark, comment, and share videos
- **User Profiles**: View creator profiles and stats
- **Smooth Animations**: Spring physics and micro-interactions
- **Haptic Feedback**: Premium tactile responses
- **Pull-to-Refresh**: Elegant loading states
- **Search & Notifications**: Modal interfaces with proper design
- **Custom Tab Bar**: Floating record button with elevation

## 🎯 User Flow

### First-Time User Experience
1. **Launch**: App opens to onboarding carousel
2. **Onboarding**: Three-page introduction with smooth animations
3. **Authentication**: Multiple sign-in options
4. **Registration**: 5-step sign-up process with validation
5. **Main App**: Tab-based navigation with placeholder content

### Returning User Experience
1. **Launch**: Direct to authentication hub
2. **Login**: Email/password or social sign-in
3. **Main App**: Full tab navigation experience

## 📱 Screenshots & Demo

The app includes:
- **Pixel-perfect design** following the specification
- **Smooth animations** with spring physics
- **Haptic feedback** for premium interactions
- **Form validation** with real-time feedback
- **Progressive disclosure** in multi-step flows
- **Accessibility support** with proper color contrast

## 🔧 Technical Implementation

### Key Features
- **Real-time Validation**: Email, password, and form validation
- **Dark Mode Compatibility**: Text always visible regardless of device appearance mode
- **Image Picker**: Profile picture upload functionality
- **Tag Selection**: Multi-select interest picker
- **Progress Tracking**: Step indicators in sign-up flow
- **Error Handling**: User-friendly error messages
- **Responsive Design**: Adapts to different screen sizes

### Performance Optimizations
- **Lazy Loading**: Efficient rendering of components
- **Animation Optimization**: Native SwiftUI animations
- **Memory Management**: Proper state lifecycle handling
- **Smooth Interactions**: 60fps target with optimized gestures

## 🔮 Future Development

### Planned Features
- **Video Feed**: TikTok-style video content
- **Services Marketplace**: Full gig discovery and application
- **Real-time Messaging**: Chat functionality
- **Content Creation**: Video recording and editing
- **Profile Management**: Complete user profiles
- **Search & Discovery**: Advanced filtering and search

### Technical Roadmap
- **Backend Integration**: API connectivity
- **Video Processing**: Recording and playback
- **Real-time Features**: Live messaging and notifications
- **Analytics**: User engagement tracking
- **Push Notifications**: Engagement and opportunity alerts

## 🛠️ Development Notes

### Code Quality
- **SwiftUI Best Practices**: Proper view composition and state management
- **Design System Adherence**: Consistent use of colors, typography, and spacing
- **Component Reusability**: DRY principles with reusable components
- **Performance**: Optimized for smooth 60fps interactions

### Testing
- **Manual Testing**: Comprehensive flow testing
- **Edge Cases**: Form validation and error states
- **Accessibility**: VoiceOver and dynamic type support
- **Device Testing**: iPhone and iPad compatibility

## 📄 License

This project is a prototype implementation for demonstration purposes.

## 🙏 Acknowledgments

- **Design System**: Based on modern iOS design principles
- **SwiftUI**: Apple's declarative UI framework
- **SF Symbols**: Apple's comprehensive icon library
- **Inspiration**: TikTok, Airbnb, and Revolut for UI/UX patterns

---

**Built with ❤️ using SwiftUI 6.2** 