import SwiftUI

// MARK: - Service Card Component
struct ServiceCard: View {
    let gig: Gig
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Business Header
                HStack(spacing: 12) {
                    // Business Logo Placeholder
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(gig.business.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 4) {
                            if gig.business.verificationStatus == .verified {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                            
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", gig.business.rating))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Urgent Badge
                    if gig.isUrgent {
                        Text("URGENT")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                }
                
                // Gig Title
                Text(gig.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Description
                Text(gig.description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(gig.categories, id: \.id) { category in
                            CategoryTag(category: category)
                        }
                    }
                    .padding(.horizontal, 1) // Prevent clipping
                }
                
                // Bottom Info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Budget")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(gig.budget.displayString)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#850101"))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(gig.applicantCount) applicants")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(gig.timeline)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Talent Card Component
struct TalentCard: View {
    let talent: TalentProfile
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Profile Header
                HStack(spacing: 12) {
                    // Profile Image
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.circle")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(talent.username)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            // Rating
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", talent.rating))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            // Completion Rate
                            Text("\(Int(talent.stats.completionRate))% completion")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        // Availability
                        AvailabilityBadge(status: talent.availability)
                    }
                    
                    Spacer()
                }
                
                // Bio
                Text(talent.bio)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(talent.categories, id: \.id) { category in
                            CategoryTag(category: category)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                
                // Stats
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Followers")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(formatNumber(talent.stats.followers))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Gigs Done")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("\(talent.completedGigs)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Response Time")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(talent.responseTime)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        } else {
            return "\(number)"
        }
    }
}

// MARK: - Category Tag Component
struct CategoryTag: View {
    let category: ServiceCategory
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Color(hex: category.color))
            
            Text(category.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: category.color).opacity(0.1))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color(hex: category.color).opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Availability Badge Component
struct AvailabilityBadge: View {
    let status: TalentProfile.AvailabilityStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .available:
            return Color.green
        case .busy:
            return Color.orange
        case .unavailable:
            return Color.red
        }
    }
}

// MARK: - Application Status Badge Component
struct ApplicationStatusBadge: View {
    let status: GigApplication.ApplicationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor.opacity(0.1))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(statusColor.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var statusColor: Color {
        switch status {
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

// MARK: - Custom Segmented Control
struct ServicesSegmentedControl: View {
    @Binding var selectedSegment: Int
    let segments: [String]
    let onSelectionChange: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedSegment = index
                        onSelectionChange(index)
                    }
                }) {
                    Text(segments[index])
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedSegment == index ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedSegment == index ? Color(hex: "#850101") : Color.clear)
                        )
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(height: 48) // Fixed height for proper layout
    }
}

// MARK: - Primary CTA Button
struct PrimaryCTAButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    
    init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(hex: "#850101"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isLoading)
        .scaleEffect(isLoading ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isLoading)
    }
}

// MARK: - Services Secondary Button (renamed to avoid conflict)
struct ServicesSecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
    }
}

// MARK: - Helper Extensions
// Note: Color.init(hex:) extension is already defined in DesignSystem.swift

// MARK: - Empty State Component
struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryCTAButton(title: actionTitle, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 48)
    }
}

// MARK: - Shimmer Loading Effect
struct ShimmerEffect: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.white.opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
                    .animation(
                        Animation.easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            )
            .onAppear {
                isAnimating = true
            }
    }
} 