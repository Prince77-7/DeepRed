import SwiftUI

// MARK: - Talent Detail View
struct TalentDetailView: View {
    let talent: TalentProfile
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Profile Details
                    profileSection
                    
                    // Portfolio
                    portfolioSection
                    
                    // Contact Section
                    contactSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                
                Text("Talent Profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    // Share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.top, 16)
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Profile Info
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
                    Text(talent.username)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(talent.bio)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    AvailabilityBadge(status: talent.availability)
                }
                
                Spacer()
            }
            
            // Categories
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(talent.categories, id: \.id) { category in
                        CategoryTag(category: category)
                    }
                }
            }
            
            // Stats
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rating")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f", talent.rating))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gigs Done")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("\(talent.completedGigs)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Response Time")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(talent.responseTime)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Portfolio Section
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Portfolio videos would be displayed here")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        VStack(spacing: 16) {
            PrimaryCTAButton(title: "Contact Talent") {
                // Contact action
            }
            
            ServicesSecondaryButton(title: "View Full Profile") {
                // View profile action
            }
        }
    }
}

// MARK: - Preview
struct TalentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TalentDetailView(talent: ServicesModels.sampleTalentProfile)
    }
} 
