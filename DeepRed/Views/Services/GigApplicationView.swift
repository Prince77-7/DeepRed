import SwiftUI

// MARK: - Gig Application View
struct GigApplicationView: View {
    let gig: Gig
    @Environment(\.dismiss) private var dismiss
    @State private var proposal = ""
    @State private var quotedPrice = ""
    @State private var proposedTimeline = ""
    @State private var selectedPortfolioVideo: String?
    @State private var isSubmitting = false
    
    // Portfolio videos - in a real app, these would come from the user's profile
    private let portfolioVideos = [
        "Tech Review Demo",
        "Brand Campaign 2024",
        "Product Launch Video",
        "Social Media Series"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Gig Summary
                    gigSummarySection
                    
                    // Proposal Section
                    proposalSection
                    
                    // Portfolio Section
                    portfolioSection
                    
                    // Pricing Section
                    pricingSection
                    
                    // Timeline Section
                    timelineSection
                    
                    // Submit Section
                    submitSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
                    .background(Color.white)
        .navigationBarHidden(true)
        .dismissKeyboardOnBackgroundTap()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Top Bar
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Text("Apply for Gig")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear.frame(width: 32, height: 32)
            }
            .padding(.top, 16)
            
            // Motivational Header
            VStack(spacing: 8) {
                Text("Your Pitch")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Show them why you're the perfect fit for this project")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Gig Summary Section
    private var gigSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gig Summary")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(gig.business.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(gig.title)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Text(gig.budget.displayString)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#850101"))
                }
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(gig.categories, id: \.id) { category in
                            CategoryTag(category: category)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Proposal Section
    private var proposalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Proposal")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Explain why you're the right fit and how you'll approach this project")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $proposal)
                        .font(.system(size: 16))
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(proposal.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                        )
                        .frame(minHeight: 120)
                    
                    if proposal.isEmpty {
                        Text("Hi there! I'm excited about this opportunity because...")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                            .allowsHitTesting(false)
                    }
                }
                
                HStack {
                    Spacer()
                    Text("\(proposal.count)/500")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Portfolio Section
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Portfolio Showcase")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Attach one of your best videos to showcase your work")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(portfolioVideos.indices, id: \.self) { index in
                    let video = portfolioVideos[index]
                    
                    Button(action: {
                        selectedPortfolioVideo = video
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        HStack(spacing: 16) {
                            // Video Thumbnail
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(width: 60, height: 45)
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.secondary)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(video)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("2:30 • 15K views")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Selection Indicator
                            if selectedPortfolioVideo == video {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "#850101"))
                            } else {
                                Image(systemName: "circle")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .background(selectedPortfolioVideo == video ? Color(hex: "#850101").opacity(0.05) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedPortfolioVideo == video ? Color(hex: "#850101") : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Pricing Section
    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Quote")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("What's your price for this project? (Budget: \(gig.budget.displayString))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Text("$")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                TextField("Enter your price", text: $quotedPrice)
                    .font(.system(size: 20, weight: .semibold))
                    .keyboardType(.numberPad)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(quotedPrice.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Timeline Section
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Delivery Timeline")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("When can you deliver this project? (Requested: \(gig.timeline))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            TextField("e.g., 1 week, 10 days", text: $proposedTimeline)
                .font(.system(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(proposedTimeline.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Submit Section
    private var submitSection: some View {
        VStack(spacing: 16) {
            // Confidence boost
            VStack(spacing: 8) {
                Text("Ready to Win This Gig?")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Your proposal will be sent directly to \(gig.business.name)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            PrimaryCTAButton(
                title: "Submit Application",
                isLoading: isSubmitting
            ) {
                submitApplication()
            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1.0 : 0.6)
            
            // Save as draft option
            Button(action: {
                // Save as draft
            }) {
                Text("Save as Draft")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 16)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !proposal.isEmpty && 
        !quotedPrice.isEmpty && 
        !proposedTimeline.isEmpty && 
        selectedPortfolioVideo != nil
    }
    
    // MARK: - Actions
    private func submitApplication() {
        guard isFormValid else { return }
        
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            
            // Show success feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Dismiss modal
            dismiss()
        }
    }
}

// MARK: - Preview
struct GigApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        GigApplicationView(gig: ServicesModels.sampleGigs[0])
    }
} 