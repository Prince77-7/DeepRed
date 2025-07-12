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

// MARK: - Post Content Type

enum PostContentType: String, Codable, CaseIterable {
    case video = "video"
    case text = "text"
    case image = "image"
    
    var displayName: String {
        switch self {
        case .video: return "Video"
        case .text: return "Text"
        case .image: return "Image"
        }
    }
    
    var iconName: String {
        switch self {
        case .video: return "video.fill"
        case .text: return "text.alignleft"
        case .image: return "photo.fill"
        }
    }
}

// MARK: - Post Content Data

struct PostContent: Codable {
    // Video content
    let videoThumbnail: String?
    let duration: TimeInterval?
    let musicTitle: String?
    
    // Text content
    let textContent: String?
    let textStyle: TextStyle?
    
    // Image content
    let imageURL: String?
    let imageCaption: String?
    let imageAltText: String?
    
    init(video: String, duration: TimeInterval, musicTitle: String? = nil) {
        self.videoThumbnail = video
        self.duration = duration
        self.musicTitle = musicTitle
        self.textContent = nil
        self.textStyle = nil
        self.imageURL = nil
        self.imageCaption = nil
        self.imageAltText = nil
    }
    
    init(text: String, style: TextStyle = .normal) {
        self.textContent = text
        self.textStyle = style
        self.videoThumbnail = nil
        self.duration = nil
        self.musicTitle = nil
        self.imageURL = nil
        self.imageCaption = nil
        self.imageAltText = nil
    }
    
    init(image: String, caption: String? = nil, altText: String? = nil) {
        self.imageURL = image
        self.imageCaption = caption
        self.imageAltText = altText
        self.videoThumbnail = nil
        self.duration = nil
        self.musicTitle = nil
        self.textContent = nil
        self.textStyle = nil
    }
}

enum TextStyle: String, Codable, CaseIterable {
    case normal = "normal"
    case bold = "bold"
    case italic = "italic"
    case quote = "quote"
    case code = "code"
    case heading = "heading"
    
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .bold: return "Bold"
        case .italic: return "Italic"
        case .quote: return "Quote"
        case .code: return "Code"
        case .heading: return "Heading"
        }
    }
}

// MARK: - Video/Post Model

struct Post: Identifiable, Codable {
    let id: UUID
    let user: User
    let contentType: PostContentType
    let content: PostContent
    let caption: String
    let likeCount: Int
    let commentCount: Int
    let shareCount: Int
    let viewCount: Int
    let isLiked: Bool
    let isBookmarked: Bool
    let createdAt: Date
    let tags: [String]
    let location: String?
    
    init(user: User, contentType: PostContentType, content: PostContent, caption: String, likeCount: Int, commentCount: Int, shareCount: Int, viewCount: Int, isLiked: Bool, isBookmarked: Bool, createdAt: Date, tags: [String], location: String? = nil) {
        self.id = UUID()
        self.user = user
        self.contentType = contentType
        self.content = content
        self.caption = caption
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.viewCount = viewCount
        self.isLiked = isLiked
        self.isBookmarked = isBookmarked
        self.createdAt = createdAt
        self.tags = tags
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Generate new UUID when decoding
        self.user = try container.decode(User.self, forKey: .user)
        self.contentType = try container.decode(PostContentType.self, forKey: .contentType)
        self.content = try container.decode(PostContent.self, forKey: .content)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.shareCount = try container.decode(Int.self, forKey: .shareCount)
        self.viewCount = try container.decode(Int.self, forKey: .viewCount)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
        self.isBookmarked = try container.decode(Bool.self, forKey: .isBookmarked)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
    
    private enum CodingKeys: String, CodingKey {
        case user, contentType, content, caption, likeCount, commentCount, shareCount, viewCount, isLiked, isBookmarked, createdAt, tags, location
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
    
    // Computed properties for backward compatibility
    var videoThumbnail: String { content.videoThumbnail ?? "" }
    var duration: TimeInterval { content.duration ?? 0 }
    var musicTitle: String? { content.musicTitle }
}

// Legacy VideoPost typealias for backward compatibility
typealias VideoPost = Post

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
    
    // MARK: - Sample Posts (Mixed Content)
    static let sampleVideos: [Post] = [
        // Video Post
        Post(
            user: sampleUsers[0],
            contentType: .video,
            content: PostContent(video: "video.thumbnail.1", duration: 45.0, musicTitle: "Creative Flow - Ambient Beats"),
            caption: "5 design principles that changed how I create content ✨ Which one resonates with you most? #DesignTips #ContentCreator",
            likeCount: 12400,
            commentCount: 234,
            shareCount: 89,
            viewCount: 156800,
            isLiked: false,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 4), // 4 hours ago
            tags: ["Design", "Tips", "Creative"],
            location: "New York, NY"
        ),
        // Text Post
        Post(
            user: sampleUsers[1],
            contentType: .text,
            content: PostContent(text: "The hardest part about building a startup isn't the code or the marketing—it's the moments of doubt when you're not sure if anyone actually needs what you're building.\n\nBut here's what I've learned: those moments of uncertainty are where the magic happens. They force you to really listen to your users, to pivot when necessary, and to build something that truly matters.\n\nDay 30 update: 1,000 users and counting. The journey continues... 🚀", style: .normal),
            caption: "Building my first SaaS product from scratch 🚀 Day 30 update: we just hit 1000 users! The journey continues...",
            likeCount: 8900,
            commentCount: 456,
            shareCount: 123,
            viewCount: 89400,
            isLiked: true,
            isBookmarked: true,
            createdAt: Date().addingTimeInterval(-3600 * 8), // 8 hours ago
            tags: ["Tech", "Startup", "SaaS"],
            location: "Austin, TX"
        ),
        // Image Post
        Post(
            user: sampleUsers[2],
            contentType: .image,
            content: PostContent(image: "morning.routine.image", caption: "My 15-minute morning routine setup", altText: "Clean desk with journal, water bottle, and workout mat"),
            caption: "15-minute morning routine that transforms your entire day 💪 Try this for one week and feel the difference! #MorningMotivation #Wellness",
            likeCount: 23600,
            commentCount: 789,
            shareCount: 234,
            viewCount: 234700,
            isLiked: false,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 12), // 12 hours ago
            tags: ["Fitness", "Wellness", "Routine"],
            location: "Los Angeles, CA"
        ),
        // Video Post
        Post(
            user: sampleUsers[3],
            contentType: .video,
            content: PostContent(video: "video.thumbnail.4", duration: 90.0, musicTitle: "Original Mix - Alex Thompson"),
            caption: "The secret to mixing vocals that sit perfectly in the mix 🎵 Studio techniques that pros don't want you to know!",
            likeCount: 15300,
            commentCount: 345,
            shareCount: 67,
            viewCount: 98500,
            isLiked: true,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 18), // 18 hours ago
            tags: ["Music", "Production", "Tutorial"],
            location: "Nashville, TN"
        ),
        // Text Post
        Post(
            user: currentUser,
            contentType: .text,
            content: PostContent(text: "Personal branding isn't about creating a fake version of yourself—it's about amplifying the best parts of who you already are.\n\nHere's what I learned after 2 years and 10M+ views:\n\n1. Authenticity beats perfection every time\n2. Consistency matters more than viral moments\n3. Your audience wants to see the real you, not just the highlight reel\n4. Value first, promotion second\n5. Building trust takes time but pays dividends\n\nThe creators who last are the ones who stay true to themselves while serving their audience. Everything else is just noise.", style: .normal),
            caption: "Why 90% of content creators fail at personal branding 📱 Here's what I learned after 2 years and 10M+ views...",
            likeCount: 34500,
            commentCount: 1200,
            shareCount: 456,
            viewCount: 456800,
            isLiked: false,
            isBookmarked: true,
            createdAt: Date().addingTimeInterval(-3600 * 24), // 1 day ago
            tags: ["Marketing", "Branding", "CreatorTips"],
            location: "San Francisco, CA"
        ),
        // Image Post
        Post(
            user: sampleUsers[4],
            contentType: .image,
            content: PostContent(image: "design.inspiration.image", caption: "Latest brand identity work", altText: "Colorful brand identity design with logo variations"),
            caption: "Just finished this brand identity for a sustainable fashion startup 🌿 The colors represent growth, authenticity, and innovation. What do you think?",
            likeCount: 7200,
            commentCount: 156,
            shareCount: 89,
            viewCount: 45600,
            isLiked: false,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 36), // 36 hours ago
            tags: ["Design", "Branding", "Sustainability"],
            location: "Portland, OR"
        ),
        // Video Post
        Post(
            user: sampleUsers[0],
            contentType: .video,
            content: PostContent(video: "video.thumbnail.6", duration: 75.0, musicTitle: "Focus Flow - Lo-Fi Beats"),
            caption: "Quick design tip: Use the 60-30-10 rule for color balance ✨ 60% dominant color, 30% secondary, 10% accent. Works every time!",
            likeCount: 18900,
            commentCount: 287,
            shareCount: 156,
            viewCount: 178500,
            isLiked: true,
            isBookmarked: false,
            createdAt: Date().addingTimeInterval(-3600 * 48), // 2 days ago
            tags: ["Design", "Tips", "Color"],
            location: "New York, NY"
        ),
        // Text Post
        Post(
            user: sampleUsers[2],
            contentType: .text,
            content: PostContent(text: "Reminder: Your progress doesn't have to be perfect to be powerful.\n\nThat 10-minute walk counts.\nThat healthy meal you chose counts.\nThat extra hour of sleep counts.\nThat moment of kindness to yourself counts.\n\nSmall steps, consistently taken, create extraordinary transformations. You don't need to completely overhaul your life overnight. You just need to show up for yourself, one choice at a time.\n\nWhat's one small step you're taking today? 💪", style: .normal),
            caption: "Progress over perfection, always 💪 Small steps lead to big changes! #MindsetMonday #GrowthMindset",
            likeCount: 41200,
            commentCount: 892,
            shareCount: 567,
            viewCount: 298700,
            isLiked: false,
            isBookmarked: true,
            createdAt: Date().addingTimeInterval(-3600 * 72), // 3 days ago
            tags: ["Mindset", "Growth", "Motivation"],
            location: "Los Angeles, CA"
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