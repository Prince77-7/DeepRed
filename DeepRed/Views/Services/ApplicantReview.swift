import SwiftUI

// MARK: - Applicant Review View (Digital Casting Room)
struct ApplicantReview: View {
    let gig: Gig
    @Environment(\.dismiss) private var dismiss
    @State private var applications = sampleApplications
    @State private var currentIndex = 0
    @State private var swipeOffset: CGSize = .zero
    @State private var selectedApplication: GigApplication?
    @State private var showingFullProfile = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Casting Room
                castingRoomSection
                
                // Action Controls
                actionControlsSection
            }
                    .background(Color.white)
        .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingFullProfile) {
            if let application = selectedApplication {
                ApplicantDetailView(application: application)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Digital Casting Room")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(gig.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: {
                    // Filter action
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Stats Bar
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(applications.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#850101"))
                    Text("Applicants")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(currentIndex + 1)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    Text("Current")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 4) {
                    Text("\(applications.count - currentIndex - 1)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.blue)
                    Text("Remaining")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 20)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Casting Room Section
    private var castingRoomSection: some View {
        GeometryReader { geometry in
            ZStack {
                // Background cards (for depth effect)
                ForEach(applications.indices.reversed(), id: \.self) { index in
                    if index >= currentIndex && index < currentIndex + 3 {
                        ApplicantCard(
                            application: applications[index],
                            isActive: index == currentIndex,
                            zIndex: index == currentIndex ? 2 : (index == currentIndex + 1 ? 1 : 0)
                        ) {
                            selectedApplication = applications[index]
                            showingFullProfile = true
                        }
                        .offset(
                            x: index == currentIndex ? swipeOffset.width : 0,
                            y: CGFloat(index - currentIndex) * 8
                        )
                        .scaleEffect(
                            index == currentIndex ? 1.0 : (index == currentIndex + 1 ? 0.95 : 0.9)
                        )
                        .opacity(
                            index == currentIndex ? 1.0 : (index == currentIndex + 1 ? 0.8 : 0.6)
                        )
                        .rotationEffect(
                            .degrees(index == currentIndex ? Double(swipeOffset.width / 20) : 0)
                        )
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentIndex)
                        .gesture(
                            index == currentIndex ? swipeGesture : nil
                        )
                    }
                }
                
                // Empty state
                if applications.isEmpty || currentIndex >= applications.count {
                    EmptyStateView(
                        icon: "person.2.fill",
                        title: "All Done!",
                        description: "You've reviewed all applicants. Time to make your decision!",
                        actionTitle: "Review Shortlist",
                        action: {
                            // Review shortlist action
                        }
                    )
                    .padding(.horizontal, 32)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Action Controls Section
    private var actionControlsSection: some View {
        VStack(spacing: 20) {
            // Quick Actions
            if currentIndex < applications.count {
                let currentApplication = applications[currentIndex]
                
                HStack(spacing: 20) {
                    // Pass Button
                    Button(action: {
                        passApplicant()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(swipeOffset.width < -50 ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: swipeOffset)
                    
                    Spacer()
                    
                    // Info Button
                    Button(action: {
                        selectedApplication = currentApplication
                        showingFullProfile = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "#850101"))
                            
                            Text("Details")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#850101"))
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    // Shortlist Button
                    Button(action: {
                        shortlistApplicant()
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(swipeOffset.width > 50 ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: swipeOffset)
                }
                .padding(.horizontal, 40)
                
                // Swipe Instructions
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                        Text("Pass")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Text("Swipe to decide")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("Shortlist")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.bottom, 34) // Safe area bottom
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -2)
    }
    
    // MARK: - Swipe Gesture
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                swipeOffset = value.translation
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                
                if abs(value.translation.width) > threshold {
                    if value.translation.width > 0 {
                        // Swipe right - Shortlist
                        shortlistApplicant()
                    } else {
                        // Swipe left - Pass
                        passApplicant()
                    }
                } else {
                    // Return to center
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        swipeOffset = .zero
                    }
                }
            }
    }
    
    // MARK: - Actions
    private func passApplicant() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            swipeOffset = CGSize(width: -500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nextApplicant()
        }
    }
    
    private func shortlistApplicant() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            swipeOffset = CGSize(width: 500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nextApplicant()
        }
    }
    
    private func nextApplicant() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentIndex += 1
            swipeOffset = .zero
        }
    }
}

// MARK: - Applicant Card
struct ApplicantCard: View {
    let application: GigApplication
    let isActive: Bool
    let zIndex: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Profile Header
                VStack(spacing: 20) {
                    // Profile Picture and Basic Info
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.secondary.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.circle")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(application.applicant.username)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", application.applicant.rating))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text("\(application.applicant.completedGigs) gigs")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            AvailabilityBadge(status: application.applicant.availability)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Bio
                    Text(application.applicant.bio)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(application.applicant.categories, id: \.id) { category in
                                CategoryTag(category: category)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color(hex: "#F8F9FA")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Stats Section
                VStack(spacing: 16) {
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text(formatNumber(application.applicant.stats.followers))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Followers")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f%%", application.applicant.stats.engagementRate))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Engagement")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Text(application.applicant.responseTime)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Response")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Proposal Preview
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Proposal")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if let quotedPrice = application.quotedPrice {
                                Text("$\(Int(quotedPrice))")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hex: "#850101"))
                            }
                        }
                        
                        Text(application.proposal)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Text("Timeline: \(application.proposedTimeline)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("Applied \(formatDate(application.appliedDate))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(isActive ? 0.15 : 0.08),
            radius: isActive ? 20 : 8,
            x: 0,
            y: isActive ? 8 : 4
        )
        .zIndex(Double(zIndex))
    }
    
    // MARK: - Helper Functions
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        } else {
            return "\(number)"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Applicant Detail View
struct ApplicantDetailView: View {
    let application: GigApplication
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Detailed profile content would go here
                    Text("Full applicant profile details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(40)
                }
            }
            .navigationTitle("Full Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Sample Data
private let sampleApplications: [GigApplication] = [
    GigApplication(
        gig: ServicesModels.sampleGigs[0],
        applicant: ServicesModels.sampleTalentProfile,
        proposal: "I'm excited about this TikTok campaign opportunity! With my 500K+ followers and experience in tech content, I can create engaging videos that showcase your app's features in a fun, authentic way. My recent campaign for a productivity app achieved 2M views and 15% engagement rate.",
        portfolioVideoURL: "tech_review_demo.mp4",
        quotedPrice: 1000,
        proposedTimeline: "10 days",
        appliedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
        status: .pending,
        businessResponse: nil,
        responseDate: nil
    ),
    GigApplication(
        gig: ServicesModels.sampleGigs[0],
        applicant: TalentProfile(
            username: "@designpro",
            profileImageURL: nil,
            bio: "Creative director and video producer with 8 years experience. Specialized in brand storytelling and viral content creation.",
            categories: [ServicesModels.sampleCategories[0], ServicesModels.sampleCategories[2]],
            stats: TalentStats(
                followers: 280000,
                following: 890,
                totalViews: 8500000,
                engagementRate: 6.2,
                avgRating: 4.8,
                completionRate: 96.0
            ),
            portfolioVideos: ["design_reel1.mp4", "design_reel2.mp4"],
            rating: 4.8,
            completedGigs: 32,
            responseTime: "Within 4 hours",
            availability: .available,
            hourlyRate: 85.0,
            location: "Austin, TX"
        ),
        proposal: "Your app launch deserves content that converts! I've launched 12+ tech products through TikTok, generating over 50K downloads combined. My approach focuses on authentic storytelling that showcases real user benefits.",
        portfolioVideoURL: "app_launch_case.mp4",
        quotedPrice: 1200,
        proposedTimeline: "1 week",
        appliedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        status: .pending,
        businessResponse: nil,
        responseDate: nil
    ),
    GigApplication(
        gig: ServicesModels.sampleGigs[0],
        applicant: TalentProfile(
            username: "@techinfluencer",
            profileImageURL: nil,
            bio: "Tech reviewer and early adopter. I help startups reach tech-savvy millennials through authentic product reviews and demos.",
            categories: [ServicesModels.sampleCategories[0], ServicesModels.sampleCategories[1]],
            stats: TalentStats(
                followers: 150000,
                following: 1200,
                totalViews: 4200000,
                engagementRate: 4.5,
                avgRating: 4.6,
                completionRate: 94.0
            ),
            portfolioVideos: ["tech_review1.mp4", "tech_review2.mp4"],
            rating: 4.6,
            completedGigs: 28,
            responseTime: "Within 6 hours",
            availability: .available,
            hourlyRate: 65.0,
            location: "San Francisco, CA"
        ),
        proposal: "As someone who reviews 100+ apps yearly, I know what makes users download and stick around. I'll create authentic, engaging content that highlights your app's unique value proposition to my tech-focused audience.",
        portfolioVideoURL: "app_review_demo.mp4",
        quotedPrice: 900,
        proposedTimeline: "2 weeks",
        appliedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
        status: .pending,
        businessResponse: nil,
        responseDate: nil
    )
]

// MARK: - Preview
struct ApplicantReview_Previews: PreviewProvider {
    static var previews: some View {
        ApplicantReview(gig: ServicesModels.sampleGigs[0])
    }
} 