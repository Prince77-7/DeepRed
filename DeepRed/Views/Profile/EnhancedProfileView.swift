import SwiftUI

// MARK: - Enhanced Profile View

struct EnhancedProfileView: View {
    @State private var profile = UserProfile.sampleProfile
    @State private var selectedTab: ProfileContentTab = .videos
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Header
                        ProfileHeader(
                            profile: profile,
                            isOwnProfile: true,
                            onEditProfile: {
                                showingEditProfile = true
                            },
                            onFollow: {
                                // Not applicable for own profile
                            },
                            onMessage: {
                                // Not applicable for own profile
                            },
                            onShare: {
                                showingShareSheet = true
                            }
                        )
                        .background(DeepRedDesign.Colors.primaryBackground)
                        
                        // Content Tab Bar
                        ProfileContentTabBar(selectedTab: $selectedTab)
                            .background(DeepRedDesign.Colors.primaryBackground)
                        
                        // Content Sections
                        contentSection
                            .background(DeepRedDesign.Colors.primaryBackground)
                    }
                }
                .refreshable {
                    // Handle pull to refresh
                    await refreshProfile()
                }
                .dismissKeyboardOnBackgroundTap()
            }
            .background(DeepRedDesign.Colors.primaryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                        HapticFeedback.impact(.light)
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.onyx)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                ProfileSettingsView(profile: $profile)
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(profile: $profile)
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [shareURL])
            }
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        switch selectedTab {
        case .videos:
            videosSection
        case .services:
            servicesSection
        case .achievements:
            achievementsSection
        case .about:
            aboutSection
        }
    }
    
    private var videosSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            // Pinned Video Section
            if let pinnedVideo = profile.pinnedVideo {
                pinnedVideoSection(pinnedVideo)
            }
            
            // All Videos Grid
            if !profile.recentVideos.isEmpty {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                    HStack {
                        Text("All Videos")
                            .font(DeepRedDesign.Typography.title2)
                            .fontWeight(.semibold)
                            .primaryText()
                        
                        Spacer()
                        
                        Text("\(profile.recentVideos.count) videos")
                            .font(DeepRedDesign.Typography.caption)
                            .secondaryText()
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    ProfileVideoGrid(videos: profile.recentVideos)
                }
            } else {
                emptyVideosState
            }
        }
        .padding(.top, DeepRedDesign.Spacing.lg)
    }
    
    private func pinnedVideoSection(_ videoId: String) -> some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            HStack {
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(DeepRedDesign.Colors.accent)
                    
                    Text("Pinned Video")
                        .font(DeepRedDesign.Typography.caption)
                        .fontWeight(.semibold)
                        .primaryText()
                }
                
                Spacer()
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            
            // Featured Video Card
            Button(action: {
                // Handle pinned video tap
                HapticFeedback.impact(.light)
            }) {
                Rectangle()
                    .fill(DeepRedDesign.Colors.ash)
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        VStack(spacing: DeepRedDesign.Spacing.sm) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.accent)
                            
                            Text("Featured Video")
                                .font(DeepRedDesign.Typography.body)
                                .primaryText()
                        }
                    )
                    .cornerRadius(DeepRedDesign.CornerRadius.card)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
    }
    
    private var emptyVideosState: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            Image(systemName: "video.fill")
                .font(.system(size: 64, weight: .medium))
                .foregroundColor(DeepRedDesign.Colors.graphite)
            
            VStack(spacing: DeepRedDesign.Spacing.sm) {
                Text("No Videos Yet")
                    .font(DeepRedDesign.Typography.title2)
                    .fontWeight(.semibold)
                    .primaryText()
                
                Text("Create your first video to start building your profile")
                    .font(DeepRedDesign.Typography.body)
                    .secondaryText()
                    .multilineTextAlignment(.center)
            }
            
            PrimaryCTAButton(title: "Create Video") {
                // Handle create video
                HapticFeedback.impact(.medium)
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
        .padding(.top, DeepRedDesign.Spacing.xl)
    }
    
    private var servicesSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            if let servicesProfile = profile.servicesProfile {
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Services Profile Card
                    ServicesProfileSection(servicesProfile: servicesProfile)
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    // Portfolio Section
                    portfolioSection(servicesProfile.portfolio)
                    
                    // Service Actions
                    servicesActionsSection
                }
            } else {
                emptyServicesState
            }
        }
        .padding(.top, DeepRedDesign.Spacing.lg)
    }
    
    private func portfolioSection(_ portfolio: [PortfolioItem]) -> some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            HStack {
                Text("Portfolio")
                    .font(DeepRedDesign.Typography.title2)
                    .fontWeight(.semibold)
                    .primaryText()
                
                Spacer()
                
                Text("\(portfolio.count) projects")
                    .font(DeepRedDesign.Typography.caption)
                    .secondaryText()
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DeepRedDesign.Spacing.md) {
                    ForEach(portfolio) { item in
                        PortfolioCard(item: item)
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            }
        }
    }
    
    private var servicesActionsSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.md) {
            HStack(spacing: DeepRedDesign.Spacing.md) {
                SecondaryButton("View Dashboard") {
                    // Handle dashboard navigation
                    HapticFeedback.impact(.light)
                }
                .frame(maxWidth: .infinity)
                
                SecondaryButton("Post New Gig") {
                    // Handle post gig
                    HapticFeedback.impact(.light)
                }
                .frame(maxWidth: .infinity)
            }
            
            TertiaryButton("Edit Services Profile") {
                // Handle edit services profile
                HapticFeedback.impact(.light)
            }
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
    
    private var emptyServicesState: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            Image(systemName: "briefcase.fill")
                .font(.system(size: 64, weight: .medium))
                .foregroundColor(DeepRedDesign.Colors.graphite)
            
            VStack(spacing: DeepRedDesign.Spacing.sm) {
                Text("Services Profile")
                    .font(DeepRedDesign.Typography.title2)
                    .fontWeight(.semibold)
                    .primaryText()
                
                Text("Set up your services profile to start earning from your skills")
                    .font(DeepRedDesign.Typography.body)
                    .secondaryText()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DeepRedDesign.Spacing.md)
            }
            
            PrimaryCTAButton(title: "Set Up Services") {
                // Handle setup services
                HapticFeedback.impact(.medium)
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
        .padding(.top, DeepRedDesign.Spacing.xl)
    }
    
    private var achievementsSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            // Achievement Summary
            achievementSummarySection
            
            // Categories
            ForEach(AchievementCategory.allCases, id: \.self) { category in
                achievementCategorySection(category)
            }
        }
        .padding(.top, DeepRedDesign.Spacing.lg)
    }
    
    private var achievementSummarySection: some View {
        VStack(spacing: DeepRedDesign.Spacing.md) {
            HStack {
                Text("Achievements")
                    .font(DeepRedDesign.Typography.title2)
                    .fontWeight(.semibold)
                    .primaryText()
                
                Spacer()
                
                Text("\(profile.achievements.filter(\.isUnlocked).count) / \(profile.achievements.count)")
                    .font(DeepRedDesign.Typography.caption)
                    .secondaryText()
            }
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            
            // Achievement Progress
            HStack(spacing: DeepRedDesign.Spacing.lg) {
                VStack(spacing: 2) {
                    Text("\(profile.achievements.filter(\.isUnlocked).count)")
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DeepRedDesign.Colors.accent)
                    
                    Text("Unlocked")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 2) {
                    Text("\(profile.achievements.count - profile.achievements.filter(\.isUnlocked).count)")
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .primaryText()
                    
                    Text("In Progress")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 2) {
                    Text("\(profile.experiencePoints)")
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .primaryText()
                    
                    Text("XP Points")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(DeepRedDesign.Spacing.sm)
            .background(DeepRedDesign.Colors.ash)
            .cornerRadius(DeepRedDesign.CornerRadius.button)
            .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        }
    }
    
    @ViewBuilder
    private func achievementCategorySection(_ category: AchievementCategory) -> some View {
        let categoryAchievements = profile.achievements.filter { $0.category == category }
        
        if !categoryAchievements.isEmpty {
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                HStack {
                    HStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: category.iconName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        
                        Text(category.rawValue)
                            .font(DeepRedDesign.Typography.caption)
                            .fontWeight(.semibold)
                            .primaryText()
                    }
                    
                    Spacer()
                    
                    Text("\(categoryAchievements.filter(\.isUnlocked).count) / \(categoryAchievements.count)")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                
                LazyVStack(spacing: DeepRedDesign.Spacing.xs) {
                    ForEach(categoryAchievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            // Bio Section
            if !profile.bio.isEmpty {
                aboutBioSection
            }
            
            // Social Media Metrics
            if !profile.socialMediaLinks.isEmpty {
                SocialMediaMetricsCard(socialMediaLinks: profile.socialMediaLinks)
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
            }
            
            // Stats Section
            aboutStatsSection
            
            // Account Info
            aboutAccountSection
        }
        .padding(.top, DeepRedDesign.Spacing.lg)
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
    
    private var aboutBioSection: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            Text("About")
                .font(DeepRedDesign.Typography.title2)
                .fontWeight(.semibold)
                .primaryText()
            
            Text(profile.bio)
                .font(DeepRedDesign.Typography.body)
                .primaryText()
                .lineLimit(nil)
            
            if let website = profile.website {
                Link(destination: URL(string: "https://\(website)") ?? URL(string: "https://example.com")!) {
                    HStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: "link")
                            .font(.system(size: 14, weight: .medium))
                        
                        Text(website)
                            .font(DeepRedDesign.Typography.body)
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                }
            }
        }
        .padding(DeepRedDesign.Spacing.md)
        .background(DeepRedDesign.Colors.ash)
        .cornerRadius(DeepRedDesign.CornerRadius.card)
    }
    
    private var aboutStatsSection: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            Text("Statistics")
                .font(DeepRedDesign.Typography.title2)
                .fontWeight(.semibold)
                .primaryText()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DeepRedDesign.Spacing.md) {
                AboutStatCard(title: "Total Views", value: ProfileStats.formatCount(profile.stats.totalViews), icon: "eye.fill")
                AboutStatCard(title: "Total Likes", value: ProfileStats.formatCount(profile.stats.totalLikes), icon: "heart.fill")
                AboutStatCard(title: "Comments", value: ProfileStats.formatCount(profile.stats.totalComments), icon: "message.fill")
                AboutStatCard(title: "Shares", value: ProfileStats.formatCount(profile.stats.totalShares), icon: "square.and.arrow.up.fill")
                
                if let servicesProfile = profile.servicesProfile {
                    AboutStatCard(title: "Earnings", value: ProfileStats.formatEarnings(servicesProfile.totalEarnings), icon: "dollarsign.circle.fill")
                    AboutStatCard(title: "Completed", value: "\(servicesProfile.completedGigs)", icon: "checkmark.circle.fill")
                }
            }
        }
    }
    
    private var aboutAccountSection: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
            Text("Account")
                .font(DeepRedDesign.Typography.title2)
                .fontWeight(.semibold)
                .primaryText()
            
            VStack(spacing: DeepRedDesign.Spacing.sm) {
                AboutInfoRow(title: "Username", value: "@\(profile.username)")
                AboutInfoRow(title: "Email", value: profile.email)
                AboutInfoRow(title: "Level", value: "Level \(profile.level)")
                AboutInfoRow(title: "Joined", value: DateFormatter.profileJoinDate.string(from: profile.joinDate))
                
                if let location = profile.location {
                    AboutInfoRow(title: "Location", value: location)
                }
            }
        }
    }
    
    private var shareURL: String {
        "https://deepred.app/profile/\(profile.username)"
    }
    
    private func refreshProfile() async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Update profile data
        HapticFeedback.impact(.light)
    }
}

// MARK: - Supporting Views

struct PortfolioCard: View {
    let item: PortfolioItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
            // Portfolio Image
            Rectangle()
                .fill(DeepRedDesign.Colors.ash)
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Text(item.category)
                            .font(DeepRedDesign.Typography.micro)
                            .secondaryText()
                    }
                )
                .cornerRadius(DeepRedDesign.CornerRadius.button)
            
            // Portfolio Info
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                Text(item.title)
                    .font(DeepRedDesign.Typography.caption)
                    .fontWeight(.semibold)
                    .primaryText()
                    .lineLimit(2)
                
                Text(ProfileStats.formatEarnings(item.earnings))
                    .font(DeepRedDesign.Typography.micro)
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .fontWeight(.medium)
                
                if let rating = item.clientRating {
                    HStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.warning)
                        
                        Text(String(format: "%.1f", rating))
                            .font(DeepRedDesign.Typography.micro)
                            .secondaryText()
                    }
                }
            }
        }
        .frame(width: 200)
        .padding(DeepRedDesign.Spacing.sm)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.card)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct AboutStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.accent)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                Text(value)
                    .font(DeepRedDesign.Typography.title2)
                    .fontWeight(.bold)
                    .primaryText()
                
                Text(title)
                    .font(DeepRedDesign.Typography.micro)
                    .secondaryText()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DeepRedDesign.Spacing.md)
        .background(DeepRedDesign.Colors.ash)
        .cornerRadius(DeepRedDesign.CornerRadius.card)
    }
}

struct AboutInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(DeepRedDesign.Typography.body)
                .secondaryText()
            
            Spacer()
            
            Text(value)
                .font(DeepRedDesign.Typography.body)
                .primaryText()
        }
        .padding(.vertical, DeepRedDesign.Spacing.xs)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Extensions

extension DateFormatter {
    static let profileJoinDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - Preview

#Preview {
    EnhancedProfileView()
} 