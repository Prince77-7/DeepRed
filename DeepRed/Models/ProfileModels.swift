import SwiftUI
import Foundation

// MARK: - Profile Models

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    
    // Basic Information
    var username: String
    var displayName: String
    var email: String
    var bio: String
    var location: String?
    var website: String?
    var joinDate: Date
    
    // Social Media Links
    var socialMediaLinks: [SocialMediaLink]
    
    // Visual Identity
    var avatarURL: String?
    var bannerURL: String?
    var isVerified: Bool
    var verificationBadge: VerificationBadge?
    
    // Stats
    var stats: ProfileStats
    
    // Content
    var recentVideos: [String] // Video IDs
    var pinnedVideo: String? // Featured video ID
    
    // Services Integration
    var servicesProfile: ServicesProfile?
    
    // Achievements
    var achievements: [Achievement]
    var level: Int
    var experiencePoints: Int
    
    // Settings
    var settings: ProfileSettings
    
    // Social
    var collaborators: [String] // User IDs
    var collaborating: [String] // User IDs
    var isPrivate: Bool
    
    // Computed Properties
    var collaboratorCount: Int { collaborators.count }
    var collaboratingCount: Int { collaborating.count }
    var videoCount: Int { recentVideos.count }
    var completionRate: Double { servicesProfile?.completionRate ?? 0 }
    var averageRating: Double { servicesProfile?.averageRating ?? 0 }
    
    var formattedCollaboratorCount: String {
        ProfileStats.formatCount(collaboratorCount)
    }
    
    var formattedCollaboratingCount: String {
        ProfileStats.formatCount(collaboratingCount)
    }
    
    var formattedVideoCount: String {
        ProfileStats.formatCount(videoCount)
    }
    
    var nextLevelXP: Int {
        (level + 1) * 1000
    }
    
    var levelProgress: Double {
        Double(experiencePoints % 1000) / 1000.0
    }
}

struct ProfileStats: Codable {
    var totalViews: Int
    var totalLikes: Int
    var totalShares: Int
    var totalComments: Int
    var totalEarnings: Double
    var activeProjects: Int
    var completedProjects: Int
    
    static func formatCount(_ count: Int) -> String {
        switch count {
        case 0..<1000:
            return "\(count)"
        case 1000..<10000:
            return String(format: "%.1fK", Double(count) / 1000)
        case 10000..<100000:
            return String(format: "%.0fK", Double(count) / 1000)
        case 100000..<1000000:
            return String(format: "%.0fK", Double(count) / 1000)
        case 1000000...:
            return String(format: "%.1fM", Double(count) / 1000000)
        default:
            return "\(count)"
        }
    }
    
    static func formatEarnings(_ earnings: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: earnings)) ?? "$0"
    }
}

struct ServicesProfile: Codable {
    var title: String
    var skills: [String]
    var hourlyRate: Double?
    var completionRate: Double
    var averageRating: Double
    var totalEarnings: Double
    var activeGigs: Int
    var completedGigs: Int
    var responseTime: String
    var isAvailable: Bool
    var portfolio: [PortfolioItem]
    
    var formattedHourlyRate: String {
        guard let rate = hourlyRate else { return "Rate varies" }
        return "$\(Int(rate))/hr"
    }
    
    var formattedCompletionRate: String {
        return "\(Int(completionRate * 100))%"
    }
    
    var formattedRating: String {
        return String(format: "%.1f", averageRating)
    }
}

struct PortfolioItem: Codable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var imageURL: String
    var videoURL: String?
    var category: String
    var completionDate: Date
    var clientRating: Double?
    var earnings: Double
}

struct Achievement: Codable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var iconName: String
    var color: String
    var unlockedDate: Date?
    var progress: Double
    var maxProgress: Double
    var category: AchievementCategory
    var rarity: AchievementRarity
    var experiencePoints: Int
    
    var isUnlocked: Bool {
        unlockedDate != nil
    }
    
    var progressPercentage: Double {
        progress / maxProgress
    }
    
    var formattedProgress: String {
        if isUnlocked {
            return "Unlocked"
        } else {
            return "\(Int(progress))/\(Int(maxProgress))"
        }
    }
}

enum AchievementCategory: String, CaseIterable, Codable {
    case video = "Video"
    case social = "Social"
    case services = "Services"
    case earnings = "Earnings"
    case engagement = "Engagement"
    case milestone = "Milestone"
    
    var iconName: String {
        switch self {
        case .video: return "video.fill"
        case .social: return "person.2.fill"
        case .services: return "briefcase.fill"
        case .earnings: return "dollarsign.circle.fill"
        case .engagement: return "heart.fill"
        case .milestone: return "star.fill"
        }
    }
}

enum AchievementRarity: String, CaseIterable, Codable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
}

struct VerificationBadge: Codable {
    var type: VerificationType
    var verifiedDate: Date
    var description: String
    
    var iconName: String {
        switch type {
        case .creator: return "checkmark.seal.fill"
        case .business: return "building.2.fill"
        case .expert: return "star.fill"
        case .partner: return "handshake.fill"
        }
    }
    
    var color: Color {
        switch type {
        case .creator: return DeepRedDesign.Colors.accent
        case .business: return DeepRedDesign.Colors.accent
        case .expert: return DeepRedDesign.Colors.accent
        case .partner: return DeepRedDesign.Colors.accent
        }
    }
}

enum VerificationType: String, CaseIterable, Codable {
    case creator = "Creator"
    case business = "Business"
    case expert = "Expert"
    case partner = "Partner"
}

struct ProfileSettings: Codable {
    var isPrivate: Bool
    var showEmail: Bool
    var showLocation: Bool
    var showEarnings: Bool
    var allowDirectMessages: Bool
    var notificationSettings: NotificationSettings
    var privacySettings: PrivacySettings
    var contentSettings: ContentSettings
}

struct NotificationSettings: Codable {
    var pushNotifications: Bool
    var emailNotifications: Bool
    var newCollaborators: Bool
    var videoLikes: Bool
    var videoComments: Bool
    var serviceInquiries: Bool
    var paymentUpdates: Bool
    var achievements: Bool
}

struct PrivacySettings: Codable {
    var profileVisibility: ProfileVisibility
    var videoVisibility: VideoVisibility
    var servicesVisibility: ServicesVisibility
    var allowTagging: Bool
    var allowMentions: Bool
    var blockedUsers: [String]
}

enum ProfileVisibility: String, CaseIterable, Codable {
    case everyone = "Public"
    case collaborators = "Collaborators Only"
    case restricted = "Private"
}

enum VideoVisibility: String, CaseIterable, Codable {
    case everyone = "Public"
    case collaborators = "Collaborators Only"
    case restricted = "Private"
}

enum ServicesVisibility: String, CaseIterable, Codable {
    case everyone = "Public"
    case collaborators = "Collaborators Only"
    case hidden = "Hidden"
}

struct ContentSettings: Codable {
    var autoPlayVideos: Bool
    var showMatureContent: Bool
    var videoQuality: VideoQuality
    var downloadOverWiFiOnly: Bool
}

enum VideoQuality: String, CaseIterable, Codable {
    case auto = "Auto"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

// MARK: - Social Media Models

struct SocialMediaLink: Codable, Identifiable, Equatable {
    var id = UUID()
    var platform: SocialMediaPlatform
    var username: String
    var url: String
    var followerCount: Int?
    var isVerified: Bool
    var isPrimary: Bool // For highlighting main platforms
    
    var displayName: String {
        return "@\(username)"
    }
    
    var formattedFollowerCount: String? {
        guard let count = followerCount else { return nil }
        return ProfileStats.formatCount(count)
    }
}

enum SocialMediaPlatform: String, CaseIterable, Codable {
    case instagram = "Instagram"
    case tiktok = "TikTok"
    case youtube = "YouTube"
    case twitter = "X (Twitter)"
    case linkedin = "LinkedIn"
    case snapchat = "Snapchat"
    case facebook = "Facebook"
    case twitch = "Twitch"
    case discord = "Discord"
    case pinterest = "Pinterest"
    case threads = "Threads"
    case reddit = "Reddit"
    
    var iconName: String {
        switch self {
        case .instagram: return "camera.fill"
        case .tiktok: return "music.note"
        case .youtube: return "play.rectangle.fill"
        case .twitter: return "message.fill"
        case .linkedin: return "person.2.fill"
        case .snapchat: return "camera.viewfinder"
        case .facebook: return "person.3.fill"
        case .twitch: return "tv.fill"
        case .discord: return "message.badge.fill"
        case .pinterest: return "pin.fill"
        case .threads: return "at.badge.plus"
        case .reddit: return "bubble.left.and.bubble.right.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .instagram: return Color(red: 0.91, green: 0.26, blue: 0.78) // Instagram gradient approximation
        case .tiktok: return Color.black
        case .youtube: return Color.red
        case .twitter: return Color.blue
        case .linkedin: return Color(red: 0.28, green: 0.63, blue: 0.91)
        case .snapchat: return Color.yellow
        case .facebook: return Color(red: 0.26, green: 0.41, blue: 0.70)
        case .twitch: return Color.purple
        case .discord: return Color(red: 0.44, green: 0.47, blue: 0.78)
        case .pinterest: return Color.red
        case .threads: return Color.black
        case .reddit: return Color(red: 1.0, green: 0.27, blue: 0.0)
        }
    }
    
    var urlPrefix: String {
        switch self {
        case .instagram: return "https://instagram.com/"
        case .tiktok: return "https://tiktok.com/@"
        case .youtube: return "https://youtube.com/@"
        case .twitter: return "https://x.com/"
        case .linkedin: return "https://linkedin.com/in/"
        case .snapchat: return "https://snapchat.com/add/"
        case .facebook: return "https://facebook.com/"
        case .twitch: return "https://twitch.tv/"
        case .discord: return "https://discord.com/users/"
        case .pinterest: return "https://pinterest.com/"
        case .threads: return "https://threads.net/@"
        case .reddit: return "https://reddit.com/u/"
        }
    }
}

// MARK: - Sample Data

extension UserProfile {
    static let sampleProfile = UserProfile(
        username: "alexcreator",
        displayName: "Alex Chen",
        email: "alex@example.com",
        bio: "Digital creator & entrepreneur helping brands tell their story through video. 🎬 Available for collaborations & creative projects.",
        location: "San Francisco, CA",
        website: "alexchen.com",
        joinDate: Date().addingTimeInterval(-365 * 24 * 60 * 60), // 1 year ago
        socialMediaLinks: sampleSocialMediaLinks,
        avatarURL: nil,
        bannerURL: nil,
        isVerified: true,
        verificationBadge: VerificationBadge(
            type: .creator,
            verifiedDate: Date().addingTimeInterval(-90 * 24 * 60 * 60),
            description: "Verified creator with 100K+ collaborators"
        ),
        stats: ProfileStats(
            totalViews: 2500000,
            totalLikes: 187500,
            totalShares: 12300,
            totalComments: 45600,
            totalEarnings: 85000,
            activeProjects: 3,
            completedProjects: 47
        ),
        recentVideos: ["video1", "video2", "video3", "video4", "video5", "video6", "video7", "video8", "video9"],
        pinnedVideo: "video1",
        servicesProfile: ServicesProfile(
            title: "Video Creator & Brand Strategist",
            skills: ["Video Production", "Content Strategy", "Brand Development", "Social Media", "Adobe Creative Suite"],
            hourlyRate: 125.0,
            completionRate: 0.98,
            averageRating: 4.9,
            totalEarnings: 85000,
            activeGigs: 3,
            completedGigs: 47,
            responseTime: "1 hour",
            isAvailable: true,
            portfolio: [
                PortfolioItem(
                    title: "Brand Campaign Video",
                    description: "30-second promotional video for tech startup",
                    imageURL: "portfolio1",
                    videoURL: "portfolio_video1",
                    category: "Video Production",
                    completionDate: Date().addingTimeInterval(-30 * 24 * 60 * 60),
                    clientRating: 5.0,
                    earnings: 2500
                ),
                PortfolioItem(
                    title: "Social Media Content Series",
                    description: "10-part content series for lifestyle brand",
                    imageURL: "portfolio2",
                    category: "Content Strategy",
                    completionDate: Date().addingTimeInterval(-60 * 24 * 60 * 60),
                    clientRating: 4.8,
                    earnings: 5000
                )
            ]
        ),
        achievements: sampleAchievements,
        level: 15,
        experiencePoints: 15750,
        settings: ProfileSettings(
            isPrivate: false,
            showEmail: false,
            showLocation: true,
            showEarnings: true,
            allowDirectMessages: true,
            notificationSettings: NotificationSettings(
                pushNotifications: true,
                emailNotifications: true,
                newCollaborators: true,
                videoLikes: true,
                videoComments: true,
                serviceInquiries: true,
                paymentUpdates: true,
                achievements: true
            ),
            privacySettings: PrivacySettings(
                profileVisibility: .everyone,
                videoVisibility: .everyone,
                servicesVisibility: .everyone,
                allowTagging: true,
                allowMentions: true,
                blockedUsers: []
            ),
            contentSettings: ContentSettings(
                autoPlayVideos: true,
                showMatureContent: false,
                videoQuality: .auto,
                downloadOverWiFiOnly: true
            )
        ),
        collaborators: Array(repeating: "collaborator", count: 124500),
        collaborating: Array(repeating: "collaborating", count: 892),
        isPrivate: false
    )
    
    static let sampleAchievements: [Achievement] = [
        Achievement(
            title: "First Video",
            description: "Posted your first video",
            iconName: "video.fill",
            color: "blue",
            unlockedDate: Date().addingTimeInterval(-300 * 24 * 60 * 60),
            progress: 1,
            maxProgress: 1,
            category: .video,
            rarity: .common,
            experiencePoints: 100
        ),
        Achievement(
            title: "Viral Creator",
            description: "Video reached 1M views",
            iconName: "eye.fill",
            color: "red",
            unlockedDate: Date().addingTimeInterval(-120 * 24 * 60 * 60),
            progress: 1,
            maxProgress: 1,
            category: .video,
            rarity: .epic,
            experiencePoints: 1000
        ),
        Achievement(
            title: "100K Collaborators",
            description: "Reached 100,000 collaborators on DeepRed",
            iconName: "person.2.fill",
            color: "green",
            unlockedDate: Date().addingTimeInterval(-60 * 24 * 60 * 60),
            progress: 1,
            maxProgress: 1,
            category: .social,
            rarity: .rare,
            experiencePoints: 500
        ),
        Achievement(
            title: "Service Provider",
            description: "Complete your first paid service",
            iconName: "briefcase.fill",
            color: "purple",
            unlockedDate: Date().addingTimeInterval(-200 * 24 * 60 * 60),
            progress: 1,
            maxProgress: 1,
            category: .services,
            rarity: .uncommon,
            experiencePoints: 250
        ),
        Achievement(
            title: "Top Earner",
            description: "Earn $50,000 from services",
            iconName: "dollarsign.circle.fill",
            color: "orange",
            unlockedDate: Date().addingTimeInterval(-30 * 24 * 60 * 60),
            progress: 1,
            maxProgress: 1,
            category: .earnings,
            rarity: .legendary,
            experiencePoints: 2000
        ),
        Achievement(
            title: "Million Views",
            description: "Reach 1 million total views",
            iconName: "eye.fill",
            color: "red",
            unlockedDate: nil,
            progress: 850000,
            maxProgress: 1000000,
            category: .engagement,
            rarity: .epic,
            experiencePoints: 1000
        )
    ]
    
    static let sampleSocialMediaLinks: [SocialMediaLink] = [
        SocialMediaLink(
            platform: .instagram,
            username: "alexcreator",
            url: "https://instagram.com/alexcreator",
            followerCount: 124500,
            isVerified: true,
            isPrimary: true
        ),
        SocialMediaLink(
            platform: .tiktok,
            username: "alexcreator",
            url: "https://tiktok.com/@alexcreator",
            followerCount: 89200,
            isVerified: true,
            isPrimary: true
        ),
        SocialMediaLink(
            platform: .youtube,
            username: "alexcreator",
            url: "https://youtube.com/@alexcreator",
            followerCount: 45300,
            isVerified: true,
            isPrimary: true
        )
    ]
} 