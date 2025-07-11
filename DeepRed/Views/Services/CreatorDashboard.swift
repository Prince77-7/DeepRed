import SwiftUI

// MARK: - Creator Dashboard View
struct CreatorDashboard: View {
    @State private var applications = sampleApplications
    @State private var selectedFilter: ApplicationFilter = .all
    @State private var isLoading = false
    
    enum ApplicationFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case viewed = "Viewed"
        case shortlisted = "Shortlisted"
        case accepted = "Accepted"
        case declined = "Declined"
        
        var color: Color {
            switch self {
            case .all:
                return Color.primary
            case .pending:
                return Color.orange
            case .viewed:
                return Color.blue
            case .shortlisted:
                return Color.purple
            case .accepted:
                return Color.green
            case .declined:
                return Color.red
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Filter Tabs
                filterSection
                
                // Applications List
                applicationsSection
            }
                    .background(Color.white)
        .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Applications")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Track your gig applications")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Stats Summary
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(filteredApplications.count)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#850101"))
                    
                    Text(selectedFilter == .all ? "Total" : selectedFilter.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Quick Stats
            quickStatsSection
        }
        .padding(.bottom, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        HStack(spacing: 0) {
            ForEach(ApplicationFilter.allCases.dropFirst(), id: \.rawValue) { filter in
                let count = applications.filter { $0.status.rawValue.lowercased() == filter.rawValue.lowercased() }.count
                
                VStack(spacing: 4) {
                    Text("\(count)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(filter.color)
                    
                    Text(filter.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                if filter != ApplicationFilter.allCases.last {
                    Divider()
                        .frame(height: 30)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "#F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ApplicationFilter.allCases, id: \.rawValue) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter,
                        color: filter.color
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = filter
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Applications Section
    private var applicationsSection: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if isLoading {
                    loadingView
                } else if filteredApplications.isEmpty {
                    emptyStateView
                } else {
                    ForEach(filteredApplications) { application in
                        ApplicationCard(application: application) {
                            // Handle application tap
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .refreshable {
            await refreshApplications()
        }
    }
    
    // MARK: - Computed Properties
    private var filteredApplications: [GigApplication] {
        if selectedFilter == .all {
            return applications
        } else {
            return applications.filter { $0.status.rawValue.lowercased() == selectedFilter.rawValue.lowercased() }
        }
    }
    
    // MARK: - Views
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerEffect()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: selectedFilter == .all ? "briefcase" : "doc.text.magnifyingglass",
            title: selectedFilter == .all ? "No Applications Yet" : "No \(selectedFilter.rawValue) Applications",
            description: selectedFilter == .all 
                ? "Start applying for gigs to see them here"
                : "No applications with \(selectedFilter.rawValue.lowercased()) status",
            actionTitle: selectedFilter == .all ? "Browse Gigs" : nil,
            action: selectedFilter == .all ? {
                // Navigate to gigs
            } : nil
        )
        .padding(.top, 40)
    }
    
    // MARK: - Actions
    private func refreshApplications() async {
        isLoading = true
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

// MARK: - Filter Chip Component
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color.clear)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(color, lineWidth: 1)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Application Card Component
struct ApplicationCard: View {
    let application: GigApplication
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Header with Status
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(application.gig.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text(application.gig.business.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    ApplicationStatusBadge(status: application.status)
                }
                
                // Application Details
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Applied")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(formatDate(application.appliedDate))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    if let quotedPrice = application.quotedPrice {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Quote")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("$\(Int(quotedPrice))")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#850101"))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Timeline")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(application.proposedTimeline)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                
                // Response Section (if applicable)
                if let businessResponse = application.businessResponse,
                   let responseDate = application.responseDate {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Business Response")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(formatDate(responseDate))
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(businessResponse)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    .padding(12)
                    .background(Color(hex: "#F8F9FA"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Action Buttons (status dependent)
                actionButtons
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        switch application.status {
        case .accepted:
            HStack(spacing: 12) {
                PrimaryCTAButton(title: "Start Project") {
                    // Start project action
                }
                .frame(height: 40)
                
                ServicesSecondaryButton(title: "View Details") {
                    // View details action
                }
                .frame(height: 40)
            }
            
        case .pending, .viewed:
            HStack {
                Text("⏱️ Waiting for response...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Withdraw") {
                    // Withdraw action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
            }
            
        case .declined:
            HStack {
                Text("❌ Application declined")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Apply Again") {
                    // Apply again action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#850101"))
            }
            
        case .shortlisted:
            HStack {
                Text("🌟 You're shortlisted!")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.purple)
                
                Spacer()
                
                Button("Send Message") {
                    // Send message action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#850101"))
            }
        }
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Sample Data
private let sampleApplications: [GigApplication] = [
    GigApplication(
        gig: ServicesModels.sampleGigs[0],
        applicant: ServicesModels.sampleTalentProfile,
        proposal: "I'm excited about this TikTok campaign opportunity! With my 500K+ followers and experience in tech content, I can create engaging videos that showcase your app's features in a fun, authentic way.",
        portfolioVideoURL: "tech_review_demo.mp4",
        quotedPrice: 1000,
        proposedTimeline: "10 days",
        appliedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        status: .viewed,
        businessResponse: nil,
        responseDate: nil
    ),
    GigApplication(
        gig: ServicesModels.sampleGigs[1],
        applicant: ServicesModels.sampleTalentProfile,
        proposal: "I specialize in developing brand voice strategies for B2B SaaS companies. I've helped 15+ tech startups establish their unique voice and create content that converts.",
        portfolioVideoURL: "brand_strategy_case.mp4",
        quotedPrice: 1800,
        proposedTimeline: "2 weeks",
        appliedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
        status: .shortlisted,
        businessResponse: "Great portfolio! We'd like to schedule a call to discuss your approach.",
        responseDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
    ),
    GigApplication(
        gig: Gig(
            title: "Instagram Reels for Fashion Brand",
            description: "Create 3 Instagram Reels showcasing our summer collection",
            business: Business(
                name: "StyleCo",
                logoURL: nil,
                description: "Fashion brand",
                industry: "Fashion",
                verificationStatus: .verified,
                rating: 4.5,
                totalGigs: 12,
                memberSince: Date(),
                location: "NYC"
            ),
            budget: BudgetRange(min: 600, max: 800, currency: "USD"),
            categories: [ServicesModels.sampleCategories[0]],
            deliverables: ["3 Instagram Reels", "Raw footage"],
            timeline: "1 week",
            postedDate: Date(),
            deadline: nil,
            status: .open,
            applicantCount: 8,
            isUrgent: false,
            requirements: "Fashion-focused content creator"
        ),
        applicant: ServicesModels.sampleTalentProfile,
        proposal: "I love creating fashion content and have worked with several clothing brands before.",
        portfolioVideoURL: "fashion_reel.mp4",
        quotedPrice: 700,
        proposedTimeline: "5 days",
        appliedDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
        status: .accepted,
        businessResponse: "Congratulations! We'd love to work with you. When can you start?",
        responseDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())
    )
]

// MARK: - Preview
struct CreatorDashboard_Previews: PreviewProvider {
    static var previews: some View {
        CreatorDashboard()
    }
} 