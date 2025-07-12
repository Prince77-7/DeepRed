import SwiftUI

// MARK: - Main App View

struct MainAppView: View {
    var body: some View {
        NativeTabBar()
    }
}

// MARK: - Tab Views (Placeholder Content)

struct HomeView: View {
    var body: some View {
        HomeFeedView()
    }
}

struct ServicesView: View {
    var body: some View {
        ServicesMarketplaceHub()
    }
}

struct RecordView: View {
    var body: some View {
        // Empty view - recording handled by tab bar button
        EmptyView()
    }
}

struct InboxView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    // Header
                    HStack {
                        Text("Inbox")
                            .font(DeepRedDesign.Typography.title1)
                            .primaryText()
                        
                        Spacer()
                        
                        Button(action: {
                            // Handle new message
                            HapticFeedback.impact(.light)
                        }) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.onyx)
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    // Content
                    VStack(spacing: DeepRedDesign.Spacing.lg) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        
                        Text("Your Inbox")
                            .font(DeepRedDesign.Typography.displayTitle)
                            .primaryText()
                        
                        Text("Messages and notifications will appear here")
                            .font(DeepRedDesign.Typography.body)
                            .secondaryText()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DeepRedDesign.Spacing.md)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        EnhancedProfileView()
    }
}

// MARK: - Preview

#Preview("Main App") {
    MainAppView()
} 