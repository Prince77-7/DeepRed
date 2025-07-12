import SwiftUI

// MARK: - Profile Header Components

struct ProfileHeader: View {
    let profile: UserProfile
    let isOwnProfile: Bool
    let onEditProfile: () -> Void
    let onFollow: () -> Void
    let onMessage: () -> Void
    let onShare: () -> Void
    
    @State private var isFollowing = false
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            // Profile Avatar & Banner
            profileAvatarSection
            
            // Profile Info
            profileInfoSection
            
            // Action Buttons
            actionButtonsSection
            
            // Stats Section
            ProfileStatsSection(profile: profile)
            
            // Social Media Links
            SocialMediaLinksSection(
                socialMediaLinks: profile.socialMediaLinks,
                isOwnProfile: isOwnProfile
            )
            
            // Level Progress (if own profile)
            if isOwnProfile {
                levelProgressSection
            }
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        .padding(.vertical, DeepRedDesign.Spacing.md)
    }
    
    private var profileAvatarSection: some View {
        ZStack {
            // Avatar
            Circle()
                .fill(DeepRedDesign.Colors.ash)
                .frame(width: 120, height: 120)
                .overlay(
                    Group {
                        if let avatarURL = profile.avatarURL {
                            AsyncImage(url: URL(string: avatarURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundColor(DeepRedDesign.Colors.graphite)
                            }
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.graphite)
                        }
                    }
                )
                .clipShape(Circle())
            
            // Verification Badge
            if profile.isVerified, let badge = profile.verificationBadge {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(DeepRedDesign.Colors.primaryBackground)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: badge.iconName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(badge.color)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .frame(width: 120, height: 120)
            }
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: profile.isVerified)
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.sm) {
            // Display Name with Verification
            HStack(spacing: DeepRedDesign.Spacing.xs) {
                Text(profile.displayName)
                    .font(DeepRedDesign.Typography.title1)
                    .fontWeight(.bold)
                    .primaryText()
                
                if profile.isVerified, let badge = profile.verificationBadge {
                    Image(systemName: badge.iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(badge.color)
                }
            }
            
            // Username
            Text("@\(profile.username)")
                .font(DeepRedDesign.Typography.body)
                .secondaryText()
            
            // Location & Website
            profileMetadataSection
        }
    }
    
    private var profileMetadataSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.xs) {
            if let location = profile.location {
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text(location)
                        .font(DeepRedDesign.Typography.caption)
                        .secondaryText()
                }
            }
            
            if let website = profile.website {
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    Image(systemName: "link")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text(website)
                        .font(DeepRedDesign.Typography.caption)
                        .foregroundColor(DeepRedDesign.Colors.accent)
                }
            }
            
            // Join Date
            HStack(spacing: DeepRedDesign.Spacing.xs) {
                Image(systemName: "calendar")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.graphite)
                
                Text("Joined \(formattedJoinDate)")
                    .font(DeepRedDesign.Typography.caption)
                    .secondaryText()
            }
        }
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: DeepRedDesign.Spacing.md) {
            if isOwnProfile {
                // Edit Profile Button
                SecondaryButton("Edit Profile") {
                    onEditProfile()
                    HapticFeedback.impact(.light)
                }
                .frame(maxWidth: .infinity)
                
                // Share Profile Button
                TertiaryButton("Share") {
                    onShare()
                    HapticFeedback.impact(.light)
                }
                .frame(width: 80)
            } else {
                // Collaborate Button
                PrimaryCTAButton(title: isFollowing ? "Collaborating" : "Collaborate") {
                    isFollowing.toggle()
                    onFollow()
                    HapticFeedback.impact(.medium)
                }
                .frame(maxWidth: .infinity)
                
                // Message Button
                SecondaryButton("Message") {
                    onMessage()
                    HapticFeedback.impact(.light)
                }
                .frame(width: 100)
                
                // More Actions Button
                Button(action: {
                    onShare()
                    HapticFeedback.impact(.light)
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DeepRedDesign.Colors.onyx)
                        .frame(width: 44, height: 44)
                        .background(DeepRedDesign.Colors.ash)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private var levelProgressSection: some View {
        VStack(spacing: DeepRedDesign.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    Text("Level \(profile.level)")
                        .font(DeepRedDesign.Typography.caption)
                        .fontWeight(.semibold)
                        .primaryText()
                    
                    Text("\(profile.experiencePoints) / \(profile.nextLevelXP) XP")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                
                Spacer()
                
                Text("+\(profile.experiencePoints % 1000) XP to next level")
                    .font(DeepRedDesign.Typography.micro)
                    .secondaryText()
            }
            
            // Progress Bar
            ProgressView(value: profile.levelProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: DeepRedDesign.Colors.accent))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
        .padding(.horizontal, DeepRedDesign.Spacing.sm)
        .padding(.vertical, DeepRedDesign.Spacing.sm)
        .background(DeepRedDesign.Colors.ash)
        .clipShape(RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button))
    }
    
    private var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: profile.joinDate)
    }
}

// MARK: - Profile Stats Section

struct ProfileStatsSection: View {
    let profile: UserProfile
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.md) {
            ProfileStatCard(
                title: "Collaborators",
                value: profile.formattedCollaboratorCount,
                subtitle: "collaborators"
            )
            
            ProfileStatCard(
                title: "Collaborating",
                value: profile.formattedCollaboratingCount,
                subtitle: "collaborating"
            )
            
            ProfileStatCard(
                title: "Videos",
                value: profile.formattedVideoCount,
                subtitle: "videos"
            )
            
            if let servicesProfile = profile.servicesProfile {
                ProfileStatCard(
                    title: "Rating",
                    value: servicesProfile.formattedRating,
                    subtitle: "⭐ rating"
                )
            }
        }
    }
}

// MARK: - Profile Stat Card

struct ProfileStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.xs) {
            Text(value)
                .font(DeepRedDesign.Typography.title2)
                .fontWeight(.bold)
                .primaryText()
            
            Text(subtitle)
                .font(DeepRedDesign.Typography.micro)
                .secondaryText()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DeepRedDesign.Spacing.sm)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.button)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Achievement Card

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.sm) {
            // Achievement Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.ash)
                    .frame(width: 40, height: 40)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(achievement.isUnlocked ? .white : DeepRedDesign.Colors.graphite)
            }
            .opacity(achievement.isUnlocked ? 1.0 : 0.5)
            
            // Achievement Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    Text(achievement.title)
                        .font(DeepRedDesign.Typography.caption)
                        .fontWeight(.semibold)
                        .primaryText()
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if achievement.isUnlocked {
                        Text("Unlocked")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(DeepRedDesign.Colors.success)
                            .padding(.horizontal, DeepRedDesign.Spacing.xs)
                            .padding(.vertical, 2)
                            .background(DeepRedDesign.Colors.success.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        Text(achievement.formattedProgress)
                            .font(.system(size: 10, weight: .medium))
                            .secondaryText()
                            .padding(.horizontal, DeepRedDesign.Spacing.xs)
                            .padding(.vertical, 2)
                            .background(DeepRedDesign.Colors.ash)
                            .cornerRadius(8)
                    }
                }
                
                // Progress Bar for unlocked achievements
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progressPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: DeepRedDesign.Colors.accent))
                        .scaleEffect(x: 1, y: 0.6, anchor: .center)
                }
            }
            
            Spacer()
        }
        .padding(DeepRedDesign.Spacing.sm)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.button)
        .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Content Tab Bar

struct ProfileContentTabBar: View {
    @Binding var selectedTab: ProfileContentTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ProfileContentTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    HapticFeedback.selection()
                }) {
                    VStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == tab ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.graphite)
                        
                        Text(tab.rawValue)
                            .font(DeepRedDesign.Typography.micro)
                            .fontWeight(.medium)
                            .foregroundColor(selectedTab == tab ? DeepRedDesign.Colors.accent : DeepRedDesign.Colors.graphite)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DeepRedDesign.Spacing.sm)
                }
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
        .background(DeepRedDesign.Colors.primaryBackground)
        .overlay(
            Rectangle()
                .fill(DeepRedDesign.Colors.ash)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

enum ProfileContentTab: String, CaseIterable {
    case videos = "Videos"
    case services = "Services"
    case achievements = "Achievements"
    case about = "About"
    
    var iconName: String {
        switch self {
        case .videos: return "video.fill"
        case .services: return "briefcase.fill"
        case .achievements: return "star.fill"
        case .about: return "person.fill"
        }
    }
}

// MARK: - Video Grid

struct ProfileVideoGrid: View {
    let videos: [String]
    let columns = Array(repeating: GridItem(.flexible(), spacing: DeepRedDesign.Spacing.xs), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: DeepRedDesign.Spacing.xs) {
            ForEach(videos, id: \.self) { videoId in
                VideoThumbnail(videoId: videoId)
                    .aspectRatio(9/16, contentMode: .fit)
                    .cornerRadius(DeepRedDesign.CornerRadius.button)
                    .onTapGesture {
                        // Handle video tap
                        HapticFeedback.impact(.light)
                    }
            }
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
    }
}

struct VideoThumbnail: View {
    let videoId: String
    
    var body: some View {
        Rectangle()
            .fill(DeepRedDesign.Colors.ash)
            .overlay(
                VStack(spacing: DeepRedDesign.Spacing.sm) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text(videoId)
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
            )
            .cornerRadius(DeepRedDesign.CornerRadius.button)
    }
}

// MARK: - Services Profile Section

struct ServicesProfileSection: View {
    let servicesProfile: ServicesProfile
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.lg) {
            // Services Header
            HStack {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    Text(servicesProfile.title)
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.semibold)
                        .primaryText()
                    
                    Text(servicesProfile.formattedHourlyRate)
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(DeepRedDesign.Colors.accent)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DeepRedDesign.Spacing.xs) {
                    HStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.warning)
                        
                        Text(servicesProfile.formattedRating)
                            .font(DeepRedDesign.Typography.caption)
                            .fontWeight(.semibold)
                            .primaryText()
                    }
                    
                    Text("\(servicesProfile.completedGigs) completed")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
            }
            
            // Skills
            skillsSection
            
            // Service Stats
            serviceStatsSection
        }
        .padding(DeepRedDesign.Spacing.md)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.card)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
            Text("Skills")
                .font(DeepRedDesign.Typography.caption)
                .fontWeight(.semibold)
                .primaryText()
            
            FlowLayout(spacing: DeepRedDesign.Spacing.xs) {
                ForEach(servicesProfile.skills, id: \.self) { skill in
                    Text(skill)
                        .font(DeepRedDesign.Typography.micro)
                        .fontWeight(.medium)
                        .foregroundColor(DeepRedDesign.Colors.accent)
                        .padding(.horizontal, DeepRedDesign.Spacing.sm)
                        .padding(.vertical, DeepRedDesign.Spacing.xs)
                        .background(DeepRedDesign.Colors.accent.opacity(0.1))
                        .cornerRadius(DeepRedDesign.CornerRadius.button)
                }
            }
        }
    }
    
    private var serviceStatsSection: some View {
        HStack(spacing: DeepRedDesign.Spacing.md) {
            ServiceStatItem(
                title: "Completion Rate",
                value: servicesProfile.formattedCompletionRate,
                icon: "checkmark.circle.fill",
                color: DeepRedDesign.Colors.success
            )
            
            ServiceStatItem(
                title: "Response Time",
                value: servicesProfile.responseTime,
                icon: "clock.fill",
                color: DeepRedDesign.Colors.accent
            )
            
            ServiceStatItem(
                title: "Earnings",
                value: ProfileStats.formatEarnings(servicesProfile.totalEarnings),
                icon: "dollarsign.circle.fill",
                color: DeepRedDesign.Colors.warning
            )
        }
    }
}

struct ServiceStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(DeepRedDesign.Typography.caption)
                .fontWeight(.semibold)
                .primaryText()
            
            Text(title)
                .font(DeepRedDesign.Typography.micro)
                .secondaryText()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        var offsets: [CGPoint] = []
        var currentRow: [CGSize] = []
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        
        let availableWidth = proposal.width ?? .infinity
        
        for size in sizes {
            if currentRowWidth + size.width > availableWidth && !currentRow.isEmpty {
                // Start new row
                let rowHeight = currentRow.map(\.height).max() ?? 0
                totalHeight += rowHeight + spacing
                maxWidth = max(maxWidth, currentRowWidth)
                currentRow = [size]
                currentRowWidth = size.width
            } else {
                currentRow.append(size)
                currentRowWidth += size.width + (currentRow.count > 1 ? spacing : 0)
            }
        }
        
        // Handle last row
        if !currentRow.isEmpty {
            let rowHeight = currentRow.map(\.height).max() ?? 0
            totalHeight += rowHeight
            maxWidth = max(maxWidth, currentRowWidth)
        }
        
        // Calculate offsets
        var currentY: CGFloat = 0
        var index = 0
        
        while index < sizes.count {
            var rowSizes: [CGSize] = []
            var rowWidth: CGFloat = 0
            
            // Collect sizes for current row
            while index < sizes.count {
                let size = sizes[index]
                if rowWidth + size.width > availableWidth && !rowSizes.isEmpty {
                    break
                }
                rowSizes.append(size)
                rowWidth += size.width + (rowSizes.count > 1 ? spacing : 0)
                index += 1
            }
            
            // Calculate offsets for current row
            var currentX: CGFloat = 0
            let rowHeight = rowSizes.map(\.height).max() ?? 0
            
            for size in rowSizes {
                offsets.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
            }
            
            currentY += rowHeight + spacing
        }
        
        return (offsets, CGSize(width: maxWidth, height: totalHeight))
    }
}

// MARK: - Social Media Components

struct SocialMediaLinksSection: View {
    let socialMediaLinks: [SocialMediaLink]
    let isOwnProfile: Bool
    @State private var showingSocialMediaEditor = false
    
    var body: some View {
        Group {
            if !socialMediaLinks.isEmpty {
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                    HStack {
                        Text("Social Media")
                            .font(DeepRedDesign.Typography.caption)
                            .fontWeight(.semibold)
                            .primaryText()
                        
                        Spacer()
                        
                        if isOwnProfile {
                            Button("Edit") {
                                showingSocialMediaEditor = true
                                HapticFeedback.impact(.light)
                            }
                            .font(DeepRedDesign.Typography.caption)
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        }
                    }
                    
                    // Primary platforms (fixed layout)
                    let primaryLinks = socialMediaLinks.filter(\.isPrimary)
                    if !primaryLinks.isEmpty {
                        HStack(spacing: DeepRedDesign.Spacing.sm) {
                            ForEach(primaryLinks) { link in
                                SocialMediaCard(link: link, style: .primary)
                            }
                        }
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    }
                    
                    // Secondary platforms (compact list)
                    let secondaryLinks = socialMediaLinks.filter { !$0.isPrimary }
                    if !secondaryLinks.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DeepRedDesign.Spacing.xs), count: 2), spacing: DeepRedDesign.Spacing.xs) {
                            ForEach(secondaryLinks) { link in
                                SocialMediaCard(link: link, style: .secondary)
                            }
                        }
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    }
                }
            } else {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingSocialMediaEditor) {
            SocialMediaEditorView()
        }
    }
}

struct SocialMediaCard: View {
    let link: SocialMediaLink
    let style: CardStyle
    
    enum CardStyle {
        case primary
        case secondary
    }
    
    var body: some View {
        Button(action: {
            openSocialMediaLink()
            HapticFeedback.impact(.light)
        }) {
            Group {
                switch style {
                case .primary:
                    primaryCardContent
                case .secondary:
                    secondaryCardContent
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var primaryCardContent: some View {
        VStack(spacing: DeepRedDesign.Spacing.xs) {
            // Platform icon with brand color
            ZStack {
                Circle()
                    .fill(link.platform.color)
                    .frame(width: 28, height: 28)
                
                Image(systemName: link.platform.iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Platform info
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    Text(link.platform.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .primaryText()
                        .lineLimit(1)
                    
                    if link.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                    }
                }
                
                if let followerCount = link.formattedFollowerCount {
                    Text("\(followerCount)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(link.platform.color)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DeepRedDesign.Spacing.sm)
        .padding(.horizontal, DeepRedDesign.Spacing.xs)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.button)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
    
    private var secondaryCardContent: some View {
        HStack(spacing: DeepRedDesign.Spacing.xs) {
            // Platform icon
            ZStack {
                Circle()
                    .fill(link.platform.color.opacity(0.1))
                    .frame(width: 24, height: 24)
                
                Image(systemName: link.platform.iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(link.platform.color)
            }
            
            // Platform name
            Text(link.platform.rawValue)
                .font(.system(size: 11, weight: .medium))
                .primaryText()
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, DeepRedDesign.Spacing.sm)
        .padding(.vertical, DeepRedDesign.Spacing.xs)
        .background(DeepRedDesign.Colors.ash)
        .cornerRadius(DeepRedDesign.CornerRadius.button)
        .frame(height: 32)
    }
    
    private func openSocialMediaLink() {
        guard let url = URL(string: link.url) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct SocialMediaMetricsCard: View {
    let socialMediaLinks: [SocialMediaLink]
    
    var body: some View {
        let totalFollowers = socialMediaLinks.compactMap(\.followerCount).reduce(0, +)
        let verifiedPlatforms = socialMediaLinks.filter(\.isVerified).count
        
        if !socialMediaLinks.isEmpty {
            HStack(spacing: DeepRedDesign.Spacing.lg) {
                VStack(spacing: 2) {
                    Text(ProfileStats.formatCount(totalFollowers))
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .primaryText()
                    
                    Text("Total Reach")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 2) {
                    Text("\(socialMediaLinks.count)")
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .primaryText()
                    
                    Text("Platforms")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 2) {
                    Text("\(verifiedPlatforms)")
                        .font(DeepRedDesign.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DeepRedDesign.Colors.accent)
                    
                    Text("Verified")
                        .font(DeepRedDesign.Typography.micro)
                        .secondaryText()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(DeepRedDesign.Spacing.sm)
            .background(DeepRedDesign.Colors.ash)
            .cornerRadius(DeepRedDesign.CornerRadius.button)
        }
    }
}

// MARK: - Social Media Editor

struct SocialMediaEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var socialMediaLinks: [SocialMediaLink] = []
    @State private var showingAddPlatform = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DeepRedDesign.Spacing.lg) {
                // Header
                VStack(spacing: DeepRedDesign.Spacing.sm) {
                    Text("Edit Social Media")
                        .font(DeepRedDesign.Typography.title1)
                        .fontWeight(.semibold)
                        .primaryText()
                    
                    Text("Manage your social media accounts")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DeepRedDesign.Spacing.lg)
                
                // Current Links
                if !socialMediaLinks.isEmpty {
                    VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                        Text("Connected Accounts")
                            .font(DeepRedDesign.Typography.caption)
                            .fontWeight(.semibold)
                            .primaryText()
                        
                        ForEach(socialMediaLinks) { link in
                            SocialMediaEditRow(link: link) {
                                // Remove link
                                socialMediaLinks.removeAll { $0.id == link.id }
                                HapticFeedback.impact(.light)
                            }
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                }
                
                // Add Platform Button
                Button(action: {
                    showingAddPlatform = true
                    HapticFeedback.impact(.light)
                }) {
                    HStack(spacing: DeepRedDesign.Spacing.sm) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                        
                        Text("Add Social Media Account")
                            .font(DeepRedDesign.Typography.body)
                            .fontWeight(.medium)
                            .primaryText()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(DeepRedDesign.Spacing.md)
                    .background(DeepRedDesign.Colors.ash)
                    .cornerRadius(DeepRedDesign.CornerRadius.button)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                
                Spacer()
            }
            .background(DeepRedDesign.Colors.primaryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.graphite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save changes
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            // Load existing social media links
            socialMediaLinks = UserProfile.sampleProfile.socialMediaLinks
        }
        .sheet(isPresented: $showingAddPlatform) {
            AddSocialMediaView { newLink in
                socialMediaLinks.append(newLink)
            }
        }
    }
}

struct SocialMediaEditRow: View {
    let link: SocialMediaLink
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.sm) {
            // Platform icon
            ZStack {
                Circle()
                    .fill(link.platform.color)
                    .frame(width: 32, height: 32)
                
                Image(systemName: link.platform.iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Platform info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: DeepRedDesign.Spacing.xs) {
                    Text(link.platform.rawValue)
                        .font(DeepRedDesign.Typography.caption)
                        .fontWeight(.semibold)
                        .primaryText()
                    
                    if link.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.accent)
                    }
                }
                
                Text(link.displayName)
                    .font(DeepRedDesign.Typography.micro)
                    .secondaryText()
            }
            
            Spacer()
            
            // Remove button
            Button(action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.error)
            }
        }
        .padding(DeepRedDesign.Spacing.sm)
        .background(DeepRedDesign.Colors.primaryBackground)
        .cornerRadius(DeepRedDesign.CornerRadius.button)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

struct AddSocialMediaView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (SocialMediaLink) -> Void
    
    @State private var selectedPlatform: SocialMediaPlatform = .instagram
    @State private var username: String = ""
    @State private var followerCount: String = ""
    @State private var isVerified: Bool = false
    @State private var isPrimary: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DeepRedDesign.Spacing.lg) {
                // Platform Selection
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.md) {
                    Text("Platform")
                        .font(DeepRedDesign.Typography.caption)
                        .fontWeight(.semibold)
                        .primaryText()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DeepRedDesign.Spacing.sm) {
                            ForEach(SocialMediaPlatform.allCases, id: \.self) { platform in
                                PlatformSelectionButton(
                                    platform: platform,
                                    isSelected: selectedPlatform == platform
                                ) {
                                    selectedPlatform = platform
                                    HapticFeedback.selection()
                                }
                            }
                        }
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    }
                }
                
                // Form Fields
                VStack(spacing: DeepRedDesign.Spacing.md) {
                    FormField(
                        title: "Username",
                        text: $username,
                        placeholder: "Enter your username"
                    )
                    
                    FormField(
                        title: "Followers (Optional)",
                        text: $followerCount,
                        placeholder: "e.g., 10000"
                    )
                    
                    // Options
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        HStack {
                            Text("Options")
                                .font(DeepRedDesign.Typography.caption)
                                .fontWeight(.semibold)
                                .primaryText()
                            
                            Spacer()
                        }
                        
                        Toggle("Verified Account", isOn: $isVerified)
                            .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
                        
                        Toggle("Primary Platform", isOn: $isPrimary)
                            .toggleStyle(SwitchToggleStyle(tint: DeepRedDesign.Colors.accent))
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                
                Spacer()
            }
            .background(DeepRedDesign.Colors.primaryBackground)
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.graphite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addSocialMediaAccount()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .fontWeight(.semibold)
                    .disabled(username.isEmpty)
                }
            }
        }
    }
    
    private func addSocialMediaAccount() {
        let url = "\(selectedPlatform.urlPrefix)\(username)"
        let followerCountInt = Int(followerCount)
        
        let newLink = SocialMediaLink(
            platform: selectedPlatform,
            username: username,
            url: url,
            followerCount: followerCountInt,
            isVerified: isVerified,
            isPrimary: isPrimary
        )
        
        onAdd(newLink)
        dismiss()
    }
}

struct PlatformSelectionButton: View {
    let platform: SocialMediaPlatform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DeepRedDesign.Spacing.xs) {
                ZStack {
                    Circle()
                        .fill(isSelected ? platform.color : platform.color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: platform.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : platform.color)
                }
                
                Text(platform.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .primaryText()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 60)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
            Text(title)
                .font(DeepRedDesign.Typography.caption)
                .fontWeight(.semibold)
                .primaryText()
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(DeepRedDesign.Typography.body)
        }
    }
}

// MARK: - Preview

#Preview("Profile Header") {
    ProfileHeader(
        profile: UserProfile.sampleProfile,
        isOwnProfile: true,
        onEditProfile: {},
        onFollow: {},
        onMessage: {},
        onShare: {}
    )
    .background(DeepRedDesign.Colors.primaryBackground)
}

#Preview("Social Media Links") {
    VStack(spacing: DeepRedDesign.Spacing.lg) {
        SocialMediaLinksSection(
            socialMediaLinks: UserProfile.sampleSocialMediaLinks,
            isOwnProfile: true
        )
        
        SocialMediaMetricsCard(socialMediaLinks: UserProfile.sampleSocialMediaLinks)
    }
    .background(DeepRedDesign.Colors.primaryBackground)
} 