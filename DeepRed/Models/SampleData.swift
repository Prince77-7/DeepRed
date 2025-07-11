import SwiftUI
import Foundation

// MARK: - User Model

struct User: Identifiable, Codable {
    let id: UUID
    let username: String
    let displayName: String
    let email: String
    let bio: String
    let followerCount: Int
    let followingCount: Int
    let videoCount: Int
    let profileImageName: String
    let isVerified: Bool
    let joinDate: Date
    let interests: [String]
    let location: String?
    
    init(username: String, displayName: String, email: String, bio: String, followerCount: Int, followingCount: Int, videoCount: Int, profileImageName: String, isVerified: Bool, joinDate: Date, interests: [String], location: String? = nil) {
        self.id = UUID()
        self.username = username
        self.displayName = displayName
        self.email = email
        self.bio = bio
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.videoCount = videoCount
        self.profileImageName = profileImageName
        self.isVerified = isVerified
        self.joinDate = joinDate
        self.interests = interests
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate new UUID when decoding
        self.username = try container.decode(String.self, forKey: .username)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.email = try container.decode(String.self, forKey: .email)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.followerCount = try container.decode(Int.self, forKey: .followerCount)
        self.followingCount = try container.decode(Int.self, forKey: .followingCount)
        self.videoCount = try container.decode(Int.self, forKey: .videoCount)
        self.profileImageName = try container.decode(String.self, forKey: .profileImageName)
        self.isVerified = try container.decode(Bool.self, forKey: .isVerified)
        self.joinDate = try container.decode(Date.self, forKey: .joinDate)
        self.interests = try container.decode([String].self, forKey: .interests)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
    
    private enum CodingKeys: String, CodingKey {
        case username, displayName, email, bio, followerCount, followingCount, videoCount, profileImageName, isVerified, joinDate, interests, location
    }
    
    var followerCountFormatted: String {
        if followerCount >= 1000000 {
            return String(format: "%.1fM", Double(followerCount) / 1000000.0)
        } else if followerCount >= 1000 {
            return String(format: "%.1fK", Double(followerCount) / 1000.0)
        } else {
            return "\(followerCount)"
        }
    }
}

// MARK: - Video/Post Model

struct VideoPost: Identifiable, Codable {
    let id: UUID
    let user: User
    let caption: String
    let videoThumbnail: String
    let duration: TimeInterval
    let likeCount: Int
    let commentCount: Int
    let shareCount: Int
    let viewCount: Int
    let isLiked: Bool
    let isBookmarked: Bool
    let createdAt: Date
    let tags: [String]
    let musicTitle: String?
    let location: String?
    
    init(user: User, caption: String, videoThumbnail: String, duration: TimeInterval, likeCount: Int, commentCount: Int, shareCount: Int, viewCount: Int, isLiked: Bool, isBookmarked: Bool, createdAt: Date, tags: [String], musicTitle: String? = nil, location: String? = nil) {
        self.id = UUID()
        self.user = user
        self.caption = caption
        self.videoThumbnail = videoThumbnail
        self.duration = duration
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.viewCount = viewCount
        self.isLiked = isLiked
        self.isBookmarked = isBookmarked
        self.createdAt = createdAt
        self.tags = tags
        self.musicTitle = musicTitle
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate new UUID when decoding
        self.user = try container.decode(User.self, forKey: .user)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.videoThumbnail = try container.decode(String.self, forKey: .videoThumbnail)
        self.duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.shareCount = try container.decode(Int.self, forKey: .shareCount)
        self.viewCount = try container.decode(Int.self, forKey: .viewCount)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
        self.isBookmarked = try container.decode(Bool.self, forKey: .isBookmarked)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.musicTitle = try container.decodeIfPresent(String.self, forKey: .musicTitle)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
    
    private enum CodingKeys: String, CodingKey {
        case user, caption, videoThumbnail, duration, likeCount, commentCount, shareCount, viewCount, isLiked, isBookmarked, createdAt, tags, musicTitle, location
    }
    
    var likeCountFormatted: String {
        if likeCount >= 1000000 {
            return String(format: "%.1fM", Double(likeCount) / 1000000.0)
        } else if likeCount >= 1000 {
            return String(format: "%.1fK", Double(likeCount) / 1000.0)
        } else {
            return "\(likeCount)"
        }
    }
    
    var viewCountFormatted: String {
        if viewCount >= 1000000 {
            return String(format: "%.1fM views", Double(viewCount) / 1000000.0)
        } else if viewCount >= 1000 {
            return String(format: "%.1fK views", Double(viewCount) / 1000.0)
        } else {
            return "\(viewCount) views"
        }
    }
}

// MARK: - Service/Gig Model

struct ServiceGig: Identifiable, Codable {
    let id: UUID
    let business: User
    let title: String
    let description: String
    let budget: Int
    let budgetType: BudgetType
    let category: String
    let skillsRequired: [String]
    let deadline: Date
    let location: String?
    let isRemote: Bool
    let applicantCount: Int
    let createdAt: Date
    let urgency: UrgencyLevel
    
    init(business: User, title: String, description: String, budget: Int, budgetType: BudgetType, category: String, skillsRequired: [String], deadline: Date, location: String? = nil, isRemote: Bool, applicantCount: Int, createdAt: Date, urgency: UrgencyLevel) {
        self.id = UUID()
        self.business = business
        self.title = title
        self.description = description
        self.budget = budget
        self.budgetType = budgetType
        self.category = category
        self.skillsRequired = skillsRequired
        self.deadline = deadline
        self.location = location
        self.isRemote = isRemote
        self.applicantCount = applicantCount
        self.createdAt = createdAt
        self.urgency = urgency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate new UUID when decoding
        self.business = try container.decode(User.self, forKey: .business)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.budget = try container.decode(Int.self, forKey: .budget)
        self.budgetType = try container.decode(BudgetType.self, forKey: .budgetType)
        self.category = try container.decode(String.self, forKey: .category)
        self.skillsRequired = try container.decode([String].self, forKey: .skillsRequired)
        self.deadline = try container.decode(Date.self, forKey: .deadline)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.isRemote = try container.decode(Bool.self, forKey: .isRemote)
        self.applicantCount = try container.decode(Int.self, forKey: .applicantCount)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.urgency = try container.decode(UrgencyLevel.self, forKey: .urgency)
    }
    
    private enum CodingKeys: String, CodingKey {
        case business, title, description, budget, budgetType, category, skillsRequired, deadline, location, isRemote, applicantCount, createdAt, urgency
    }
    
    enum BudgetType: String, Codable, CaseIterable {
        case fixed = "Fixed Price"
        case hourly = "Hourly Rate"
        case negotiable = "Negotiable"
    }
    
    enum UrgencyLevel: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
    }
    
    var budgetFormatted: String {
        switch budgetType {
        case .fixed:
            return "$\(budget)"
        case .hourly:
            return "$\(budget)/hr"
        case .negotiable:
            return "Negotiable"
        }
    }
}

// MARK: - Sample Data

class SampleData {
    
    // MARK: - Current User
    static let currentUser = User(
        username: "demo_user",
        displayName: "Demo User",
        email: "demo@deepred.com",
        bio: "Content creator & digital marketing specialist. Passionate about storytelling and brand building. 🎬✨",
        followerCount: 12400,
        followingCount: 847,
        videoCount: 156,
        profileImageName: "person.crop.circle.fill",
        isVerified: true,
        joinDate: Date().addingTimeInterval(-86400 * 120), // 120 days ago
        interests: ["Marketing", "Video", "Creative", "Business"],
        location: "San Francisco, CA"
    )
    
    // MARK: - Sample Users
    static let sampleUsers: [User] = [
        User(
            username: "sarah_creates",
            displayName: "Sarah Johnson",
            email: "sarah@example.com",
            bio: "Digital artist & brand strategist. Creating visual stories that connect and inspire. 🎨💫",
            followerCount: 45600,
            followingCount: 1200,
            videoCount: 89,
            profileImageName: "person.crop.circle.fill",
            isVerified: true,
            joinDate: Date().addingTimeInterval(-86400 * 200),
            interests: ["Art", "Design", "Branding"],
            location: "New York, NY"
        ),
        User(
            username: "mike_tech",
            displayName: "Mike Chen",
            email: "mike@example.com",
            bio: "Tech entrepreneur & product designer. Building the future one app at a time. 💻🚀",
            followerCount: 23800,
            followingCount: 890,
            videoCount: 124,
            profileImageName: "person.crop.circle.fill",
            isVerified: false,
            joinDate: Date().addingTimeInterval(-86400 * 90),
            interests: ["Tech", "Startup", "Design"],
            location: "Austin, TX"
        ),
        User(
            username: "emma_fitness",
            displayName: "Emma Rodriguez",
            email: "emma@example.com",
            bio: "Certified personal trainer & wellness coach. Helping you live your healthiest life. 💪🌟",
            followerCount: 78200,
            followingCount: 456,
            videoCount: 234,
            profileImageName: "person.crop.circle.fill",
            isVerified: true,
            joinDate: Date().addingTimeInterval(-86400 * 300),
            interests: ["Fitness", "Wellness", "Nutrition"],
            location: "Los Angeles, CA"
        ),
        User(
            username: "alex_music",
            displayName: "Alex Thompson",
            email: "alex@example.com",
            bio: "Music producer & audio engineer. Creating soundscapes that move your soul. 🎵🎧",
            followerCount: 34500,
            followingCount: 1100,
            videoCount: 167,
            profileImageName: "person.crop.circle.fill",
            isVerified: true,
            joinDate: Date().addingTimeInterval(-86400 * 180),
            interests: ["Music", "Audio", "Production"],
            location: "Nashville, TN"
        ),
        User(
            username: "business_solutions",
            displayName: "Nexus Solutions",
            email: "contact@nexussolutions.com",
            bio: "Leading digital marketing agency. We help brands tell their story and reach their audience. 📈💼",
            followerCount: 15600,
            followingCount: 2300,
            videoCount: 45,
            profileImageName: "building.2.crop.circle.fill",
            isVerified: true,
            joinDate: Date().addingTimeInterval(-86400 * 400),
            interests: ["Business", "Marketing", "Strategy"],
            location: "Chicago, IL"
        )
    ]
    
    // MARK: - Sample Videos
    static let sampleVideos: [VideoPost] = [
        VideoPost(
            user: sampleUsers[0],
            caption: "5 design principles that changed how I create content ✨ Which one resonates with you most? #DesignTips #ContentCreator",
            videoThumbnail: "video.thumbnail.1",
            duration: 45.0,
            likeCount: 12400,
            commentCount: 234,
            shareCount: 89,
            viewCount: 156800,
            isLiked: false,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 4), // 4 hours ago
            tags: ["Design", "Tips", "Creative"],
            musicTitle: "Creative Flow - Ambient Beats",
            location: "New York, NY"
        ),
        VideoPost(
            user: sampleUsers[1],
            caption: "Building my first SaaS product from scratch 🚀 Day 30 update: we just hit 1000 users! The journey continues...",
            videoThumbnail: "video.thumbnail.2",
            duration: 60.0,
            likeCount: 8900,
            commentCount: 456,
            shareCount: 123,
            viewCount: 89400,
            isLiked: true,
            isBookmarked: true,
            createdAt: Date().addingTimeInterval(-3600 * 8), // 8 hours ago
            tags: ["Tech", "Startup", "SaaS"],
            musicTitle: "Upbeat Motivation - Electronic",
            location: "Austin, TX"
        ),
        VideoPost(
            user: sampleUsers[2],
            caption: "15-minute morning routine that transforms your entire day 💪 Try this for one week and feel the difference! #MorningMotivation #Wellness",
            videoThumbnail: "video.thumbnail.3",
            duration: 15.0,
            likeCount: 23600,
            commentCount: 789,
            shareCount: 234,
            viewCount: 234700,
            isLiked: false,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 12), // 12 hours ago
            tags: ["Fitness", "Wellness", "Routine"],
            musicTitle: "Morning Energy - Acoustic",
            location: "Los Angeles, CA"
        ),
        VideoPost(
            user: sampleUsers[3],
            caption: "The secret to mixing vocals that sit perfectly in the mix 🎵 Studio techniques that pros don't want you to know!",
            videoThumbnail: "video.thumbnail.4",
            duration: 90.0,
            likeCount: 15300,
            commentCount: 345,
            shareCount: 67,
            viewCount: 98500,
            isLiked: true,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 18), // 18 hours ago
            tags: ["Music", "Production", "Tutorial"],
            musicTitle: "Original Mix - Alex Thompson",
            location: "Nashville, TN"
        ),
        VideoPost(
            user: currentUser,
            caption: "Why 90% of content creators fail at personal branding 📱 Here's what I learned after 2 years and 10M+ views...",
            videoThumbnail: "video.thumbnail.5",
            duration: 120.0,
            likeCount: 34500,
            commentCount: 1200,
            shareCount: 456,
            viewCount: 456800,
            isLiked: false,
            isBookmarked: true,
            createdAt: Date().addingTimeInterval(-3600 * 24), // 1 day ago
            tags: ["Marketing", "Branding", "CreatorTips"],
            musicTitle: "Inspiring Journey - Cinematic",
            location: "San Francisco, CA"
        )
    ]
    
    // MARK: - Sample Gigs
    static let sampleGigs: [ServiceGig] = [
        ServiceGig(
            business: sampleUsers[4],
            title: "Social Media Content Creator for Tech Startup",
            description: "We're looking for a creative content creator to help us build our brand presence across TikTok, Instagram, and YouTube. You'll be responsible for creating engaging videos that showcase our product features and company culture.",
            budget: 2500,
            budgetType: .fixed,
            category: "Content Creation",
            skillsRequired: ["Video Editing", "Social Media", "Storytelling"],
            deadline: Date().addingTimeInterval(86400 * 14), // 2 weeks from now
            location: nil,
            isRemote: true,
            applicantCount: 23,
            createdAt: Date().addingTimeInterval(-3600 * 6), // 6 hours ago
            urgency: .high
        ),
        ServiceGig(
            business: sampleUsers[0],
            title: "Brand Identity Design Package",
            description: "Seeking a talented designer to create a complete brand identity package including logo, color palette, typography, and brand guidelines for a new wellness startup.",
            budget: 150,
            budgetType: .hourly,
            category: "Design",
            skillsRequired: ["Logo Design", "Brand Identity", "Adobe Creative Suite"],
            deadline: Date().addingTimeInterval(86400 * 21), // 3 weeks from now
            location: "New York, NY",
            isRemote: false,
            applicantCount: 45,
            createdAt: Date().addingTimeInterval(-3600 * 12), // 12 hours ago
            urgency: .medium
        ),
        ServiceGig(
            business: sampleUsers[1],
            title: "Product Demo Video Creation",
            description: "Need a skilled video creator to produce a professional product demo video for our new mobile app. Should be engaging, informative, and optimized for social media sharing.",
            budget: 1800,
            budgetType: .fixed,
            category: "Video Production",
            skillsRequired: ["Video Production", "Motion Graphics", "Scriptwriting"],
            deadline: Date().addingTimeInterval(86400 * 10), // 10 days from now
            location: nil,
            isRemote: true,
            applicantCount: 12,
            createdAt: Date().addingTimeInterval(-3600 * 2), // 2 hours ago
            urgency: .urgent
        )
    ]
    
    // MARK: - Authentication Helper
    static func authenticateUser(email: String, password: String) -> User? {
        if email == "demo@deepred.com" && password == "password123" {
            return currentUser
        }
        return nil
    }
}

// MARK: - App State Manager

class AppStateManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    func signIn(email: String, password: String) -> Bool {
        if let user = SampleData.authenticateUser(email: email, password: password) {
            currentUser = user
            isAuthenticated = true
            return true
        }
        return false
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
} 