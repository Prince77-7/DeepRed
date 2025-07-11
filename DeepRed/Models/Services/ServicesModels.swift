import Foundation

// MARK: - Core Data Models for Services Marketplace

/// Represents a service category/skill tag
struct ServiceCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let icon: String // SF Symbol name
    let color: String // Hex color
}

/// Represents a business/company on the platform
struct Business: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let logoURL: String?
    let description: String
    let industry: String
    let verificationStatus: VerificationStatus
    let rating: Double
    let totalGigs: Int
    let memberSince: Date
    let location: String?
    
    enum VerificationStatus: String, Codable, CaseIterable {
        case verified = "Verified"
        case pending = "Pending"
        case unverified = "Unverified"
    }
}

/// Represents a gig/job posting
struct Gig: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String
    let description: String
    let business: Business
    let budget: BudgetRange
    let categories: [ServiceCategory]
    let deliverables: [String]
    let timeline: String
    let postedDate: Date
    let deadline: Date?
    let status: GigStatus
    let applicantCount: Int
    let isUrgent: Bool
    let requirements: String
    
    enum GigStatus: String, Codable, CaseIterable {
        case open = "Open"
        case inProgress = "In Progress"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }
}

/// Budget range for gigs
struct BudgetRange: Codable, Hashable {
    let min: Double
    let max: Double
    let currency: String
    
    var displayString: String {
        if min == max {
            return "$\(Int(min))"
        } else {
            return "$\(Int(min)) - $\(Int(max))"
        }
    }
}

/// Represents a creator's talent profile
struct TalentProfile: Identifiable, Codable, Hashable {
    var id = UUID()
    let username: String
    let profileImageURL: String?
    let bio: String
    let categories: [ServiceCategory]
    let stats: TalentStats
    let portfolioVideos: [String] // Video URLs
    let rating: Double
    let completedGigs: Int
    let responseTime: String
    let availability: AvailabilityStatus
    let hourlyRate: Double?
    let location: String?
    
    enum AvailabilityStatus: String, Codable, CaseIterable {
        case available = "Available"
        case busy = "Busy"
        case unavailable = "Unavailable"
    }
}

/// Creator statistics
struct TalentStats: Codable, Hashable {
    let followers: Int
    let following: Int
    let totalViews: Int
    let engagementRate: Double
    let avgRating: Double
    let completionRate: Double
}

/// Represents an application for a gig
struct GigApplication: Identifiable, Codable, Hashable {
    var id = UUID()
    let gig: Gig
    let applicant: TalentProfile
    let proposal: String
    let portfolioVideoURL: String?
    let quotedPrice: Double?
    let proposedTimeline: String
    let appliedDate: Date
    let status: ApplicationStatus
    let businessResponse: String?
    let responseDate: Date?
    
    enum ApplicationStatus: String, Codable, CaseIterable {
        case pending = "Pending"
        case viewed = "Viewed"
        case shortlisted = "Shortlisted"
        case accepted = "Accepted"
        case declined = "Declined"
    }
}

/// Represents an active project
struct Project: Identifiable, Codable, Hashable {
    var id = UUID()
    let gig: Gig
    let creator: TalentProfile
    let business: Business
    let startDate: Date
    let expectedDelivery: Date
    let actualDelivery: Date?
    let milestones: [ProjectMilestone]
    let communications: [ProjectMessage]
    let status: ProjectStatus
    let payment: PaymentInfo
    
    enum ProjectStatus: String, Codable, CaseIterable {
        case active = "Active"
        case inReview = "In Review"
        case completed = "Completed"
        case cancelled = "Cancelled"
        case disputed = "Disputed"
    }
}

/// Project milestone
struct ProjectMilestone: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String
    let description: String
    let dueDate: Date
    let isCompleted: Bool
    let completedDate: Date?
    let deliverables: [String]
}

/// Project communication message
struct ProjectMessage: Identifiable, Codable, Hashable {
    var id = UUID()
    let sender: MessageSender
    let content: String
    let timestamp: Date
    let attachments: [String]
    let isRead: Bool
    
    enum MessageSender: String, Codable {
        case creator = "Creator"
        case business = "Business"
        case system = "System"
    }
}

/// Payment information
struct PaymentInfo: Codable, Hashable {
    let totalAmount: Double
    let currency: String
    let escrowStatus: EscrowStatus
    let paymentMethod: String
    let releaseDate: Date?
    
    enum EscrowStatus: String, Codable, CaseIterable {
        case pending = "Pending"
        case escrowed = "Escrowed"
        case released = "Released"
        case disputed = "Disputed"
    }
}

// MARK: - Sample Data for Development

extension ServicesModels {
    static let sampleCategories: [ServiceCategory] = [
        ServiceCategory(name: "Video Editing", icon: "video.fill", color: "#FF6B6B"),
        ServiceCategory(name: "Social Media", icon: "heart.fill", color: "#4ECDC4"),
        ServiceCategory(name: "Content Creation", icon: "camera.fill", color: "#45B7D1"),
        ServiceCategory(name: "Brand Strategy", icon: "lightbulb.fill", color: "#F9CA24"),
        ServiceCategory(name: "Photography", icon: "camera.fill", color: "#6C5CE7"),
        ServiceCategory(name: "Animation", icon: "play.fill", color: "#A29BFE"),
        ServiceCategory(name: "Copywriting", icon: "text.alignleft", color: "#FD79A8"),
        ServiceCategory(name: "Voice Over", icon: "mic.fill", color: "#00B894")
    ]
    
    static let sampleBusiness: Business = Business(
        name: "TechFlow Studios",
        logoURL: "https://example.com/logo.png",
        description: "Leading digital marketing agency specializing in tech startups",
        industry: "Marketing & Advertising",
        verificationStatus: .verified,
        rating: 4.8,
        totalGigs: 24,
        memberSince: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date(),
        location: "San Francisco, CA"
    )
    
    static let sampleGigs: [Gig] = [
        Gig(
            title: "Create Engaging TikTok Campaign",
            description: "We need a creative influencer to create a series of 5 TikTok videos promoting our new productivity app. The content should be fun, engaging, and showcase real use cases.",
            business: sampleBusiness,
            budget: BudgetRange(min: 800, max: 1200, currency: "USD"),
            categories: [sampleCategories[0], sampleCategories[1]],
            deliverables: ["5 TikTok videos (30s each)", "1 Instagram Reel", "Content calendar"],
            timeline: "2 weeks",
            postedDate: Date(),
            deadline: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date()),
            status: .open,
            applicantCount: 12,
            isUrgent: false,
            requirements: "Must have 10k+ followers and tech-savvy audience"
        ),
        Gig(
            title: "Brand Voice Strategy Development",
            description: "Looking for a social media strategist to develop our brand voice and create content guidelines for our team.",
            business: sampleBusiness,
            budget: BudgetRange(min: 1500, max: 2000, currency: "USD"),
            categories: [sampleCategories[3], sampleCategories[1]],
            deliverables: ["Brand voice guide", "Content templates", "Social media strategy"],
            timeline: "3 weeks",
            postedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            deadline: Calendar.current.date(byAdding: .weekOfYear, value: 3, to: Date()),
            status: .open,
            applicantCount: 8,
            isUrgent: true,
            requirements: "Experience with B2B SaaS companies preferred"
        )
    ]
    
    static let sampleTalentProfile: TalentProfile = TalentProfile(
        username: "@creativemind",
        profileImageURL: "https://example.com/profile.jpg",
        bio: "Award-winning video creator specializing in tech content. 500k+ followers across platforms.",
        categories: [sampleCategories[0], sampleCategories[1], sampleCategories[2]],
        stats: TalentStats(
            followers: 524000,
            following: 1200,
            totalViews: 12500000,
            engagementRate: 4.8,
            avgRating: 4.9,
            completionRate: 98.5
        ),
        portfolioVideos: ["video1.mp4", "video2.mp4", "video3.mp4"],
        rating: 4.9,
        completedGigs: 47,
        responseTime: "Within 2 hours",
        availability: .available,
        hourlyRate: 75.0,
        location: "Los Angeles, CA"
    )
}

// MARK: - Helper class for organizing sample data
class ServicesModels {
    // Sample data organization
} 