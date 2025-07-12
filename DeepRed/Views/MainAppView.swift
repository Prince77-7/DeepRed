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

struct InfluencersView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    // Header
                    HStack {
                        Text("Influencers")
                            .font(DeepRedDesign.Typography.title1)
                            .primaryText()
                        
                        Spacer()
                        
                        Button(action: {
                            // Handle search
                            HapticFeedback.impact(.light)
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.onyx)
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    // Content
                    VStack(spacing: DeepRedDesign.Spacing.lg) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Text("Discover Influencers")
                            .font(DeepRedDesign.Typography.title1)
                            .primaryText()
                        
                        Text("Find and connect with top content creators")
                            .font(DeepRedDesign.Typography.body)
                            .secondaryText()
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxHeight: .infinity)
                    .primaryBackground()
                }
                .primaryBackground()
            }
        }
    }
}



struct SponsorsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    // Header
                    HStack {
                        Text("Sponsors")
                            .font(DeepRedDesign.Typography.title1)
                            .primaryText()
                        
                        Spacer()
                        
                        Button(action: {
                            // Handle new sponsor
                            HapticFeedback.impact(.light)
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.onyx)
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, DeepRedDesign.Spacing.sm)
                    
                    // Content
                    VStack(spacing: DeepRedDesign.Spacing.lg) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Text("Sponsor Opportunities")
                            .font(DeepRedDesign.Typography.title1)
                            .primaryText()
                        
                        Text("Connect with brands and sponsors")
                            .font(DeepRedDesign.Typography.body)
                            .secondaryText()
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxHeight: .infinity)
                    .primaryBackground()
                }
                .primaryBackground()
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