import SwiftUI

// MARK: - Onboarding Model

struct OnboardingPage {
    let title: String
    let subtitle: String
    let iconName: String
    let description: String
}

// MARK: - Onboarding View

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showAuthView = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Create & Connect",
            subtitle: "Share Your Story",
            iconName: "sparkles",
            description: "Create engaging content and connect with businesses looking for your unique talents."
        ),
        OnboardingPage(
            title: "Find Your Opportunity",
            subtitle: "Discover Amazing Gigs",
            iconName: "briefcase.fill",
            description: "Browse through hundreds of opportunities from businesses seeking creative professionals."
        ),
        OnboardingPage(
            title: "Showcase Your Talent",
            subtitle: "Build Your Portfolio",
            iconName: "mic.fill",
            description: "Display your skills, build your reputation, and earn from your creative work."
        )
    ]
    
    var body: some View {
        ZStack {
            DeepRedDesign.Colors.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Logo
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    
                    Spacer()
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.top, DeepRedDesign.Spacing.md)
                
                Spacer()
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Page Indicators
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.graphite)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, DeepRedDesign.Spacing.md)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: DeepRedDesign.Spacing.sm) {
                    if currentPage == pages.count - 1 {
                        // Last page - show "Get Started" button
                        PrimaryButton("Get Started") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showAuthView = true
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // Other pages - show "Next" and "Skip" buttons
                        HStack(spacing: DeepRedDesign.Spacing.sm) {
                            SecondaryButton("Next") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentPage += 1
                                }
                            }
                            
                            TertiaryButton("Skip") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showAuthView = true
                                }
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.bottom, DeepRedDesign.Spacing.lg)
            }
        }
        .fullScreenCover(isPresented: $showAuthView) {
            AuthenticationHubView()
        }
    }
}

// MARK: - Onboarding Page View

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.md) {
            // Icon
            Image(systemName: page.iconName)
                .font(.system(size: 80, weight: .medium))
                .foregroundColor(DeepRedDesign.Colors.accent)
                .frame(height: 100)
            
            // Title
            Text(page.title)
                .font(DeepRedDesign.Typography.displayTitle)
                .primaryText()
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text(page.subtitle)
                .font(DeepRedDesign.Typography.title2)
                .secondaryText()
                .multilineTextAlignment(.center)
            
            // Description
            Text(page.description)
                .font(DeepRedDesign.Typography.body)
                .secondaryText()
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, DeepRedDesign.Spacing.md)
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
}

// MARK: - Preview

#Preview("Onboarding") {
    OnboardingView()
} 