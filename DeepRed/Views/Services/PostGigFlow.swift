import SwiftUI

// MARK: - Post Gig Flow View
struct PostGigFlow: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: PostGigStep = .title
    @State private var isPosting = false
    
    // Form Data
    @State private var gigTitle = ""
    @State private var gigDescription = ""
    @State private var selectedCategories: Set<ServiceCategory> = []
    @State private var minBudget = ""
    @State private var maxBudget = ""
    @State private var timeline = ""
    @State private var deliverables = [""]
    @State private var requirements = ""
    @State private var isUrgent = false
    
    enum PostGigStep: Int, CaseIterable {
        case title = 0
        case description = 1
        case categories = 2
        case budget = 3
        case timeline = 4
        case deliverables = 5
        case requirements = 6
        case review = 7
        
        var title: String {
            switch self {
            case .title:
                return "What's your project?"
            case .description:
                return "Tell us more"
            case .categories:
                return "Skills needed"
            case .budget:
                return "Project budget"
            case .timeline:
                return "When do you need it?"
            case .deliverables:
                return "What will you receive?"
            case .requirements:
                return "Any special requirements?"
            case .review:
                return "Review & Post"
            }
        }
        
        var subtitle: String {
            switch self {
            case .title:
                return "Give your project a clear, compelling title"
            case .description:
                return "Describe what you need and why it's important"
            case .categories:
                return "What skills should the creator have?"
            case .budget:
                return "What's your budget range for this project?"
            case .timeline:
                return "How quickly do you need this completed?"
            case .deliverables:
                return "What specific items will the creator deliver?"
            case .requirements:
                return "Any specific requirements or preferences?"
            case .review:
                return "Review your gig details before posting"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with Progress
                headerSection
                
                // Current Step Content
                stepContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Navigation Buttons
                navigationButtons
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
                    if currentStep == .title {
                        dismiss()
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentStep = PostGigStep(rawValue: currentStep.rawValue - 1) ?? .title
                        }
                    }
                }) {
                    Image(systemName: currentStep == .title ? "xmark" : "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Text("Post a Gig")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Step Counter
                Text("\(currentStep.rawValue + 1)/\(PostGigStep.allCases.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Progress Bar
            progressBar
            
            // Step Title
            VStack(spacing: 8) {
                Text(currentStep.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(currentStep.subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Progress Bar
    private var progressBar: some View {
        HStack(spacing: 4) {
            ForEach(PostGigStep.allCases, id: \.rawValue) { step in
                RoundedRectangle(cornerRadius: 2)
                    .fill(step.rawValue <= currentStep.rawValue ? Color(hex: "#850101") : Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Step Content
    @ViewBuilder
    private var stepContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                switch currentStep {
                case .title:
                    titleStep
                case .description:
                    descriptionStep
                case .categories:
                    categoriesStep
                case .budget:
                    budgetStep
                case .timeline:
                    timelineStep
                case .deliverables:
                    deliverablesStep
                case .requirements:
                    requirementsStep
                case .review:
                    reviewStep
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // Space for navigation buttons
        }
    }
    
    // MARK: - Step Views
    private var titleStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("e.g., Create 5 TikTok videos for our app launch", text: $gigTitle)
                .font(.system(size: 18, weight: .medium))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(gigTitle.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Tips for a great title:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                tipItem("Be specific about what you need")
                tipItem("Mention the platform or medium")
                tipItem("Include quantity if applicable")
                tipItem("Keep it under 80 characters")
            }
            .padding(16)
            .background(Color(hex: "#F8F9FA"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var descriptionStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $gigDescription)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(gigDescription.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                    )
                    .frame(minHeight: 150)
                
                if gigDescription.isEmpty {
                    Text("Describe your project in detail. What's the goal? What style are you looking for? Include any brand guidelines or examples...")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .allowsHitTesting(false)
                }
            }
            
            HStack {
                Spacer()
                Text("\(gigDescription.count)/1000")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Toggle("This is urgent", isOn: $isUrgent)
                .font(.system(size: 16, weight: .medium))
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var categoriesStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select all that apply:")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ServicesModels.sampleCategories, id: \.id) { category in
                    CategorySelectionChip(
                        category: category,
                        isSelected: selectedCategories.contains(category)
                    ) {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
            }
        }
    }
    
    private var budgetStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Budget Range")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Minimum")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("500", text: $minBudget)
                                .font(.system(size: 18, weight: .semibold))
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Maximum")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("1000", text: $maxBudget)
                                .font(.system(size: 18, weight: .semibold))
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Budget Guidelines:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                tipItem("Higher budgets attract more qualified creators")
                tipItem("Be realistic about the scope of work")
                tipItem("Consider your timeline - urgent projects cost more")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var timelineStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("e.g., 1 week, 2 weeks, 1 month", text: $timeline)
                .font(.system(size: 18, weight: .medium))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(timeline.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Timeline Tips:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                tipItem("Be realistic about quality work time")
                tipItem("Allow buffer time for revisions")
                tipItem("Consider creator availability")
                tipItem("Rush jobs typically cost 25-50% more")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var deliverablesStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What will you receive?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            ForEach(deliverables.indices, id: \.self) { index in
                HStack {
                    TextField("e.g., 5 TikTok videos (30s each)", text: $deliverables[index])
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    if deliverables.count > 1 {
                        Button(action: {
                            deliverables.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            Button(action: {
                deliverables.append("")
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#850101"))
                    
                    Text("Add another deliverable")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "#850101"))
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var requirementsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $requirements)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(requirements.isEmpty ? Color.gray.opacity(0.2) : Color(hex: "#850101"), lineWidth: 1)
                    )
                    .frame(minHeight: 120)
                
                if requirements.isEmpty {
                    Text("Any specific requirements? (Optional)\n\ne.g., Must have 10K+ followers, Tech-savvy audience, Experience with B2B brands...")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Gig Preview Card
            VStack(alignment: .leading, spacing: 16) {
                Text("Gig Preview")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and urgency
                    HStack {
                        Text(gigTitle)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        if isUrgent {
                            Text("URGENT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    
                    // Description
                    Text(gigDescription)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    // Categories
                    if !selectedCategories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(selectedCategories), id: \.id) { category in
                                    CategoryTag(category: category)
                                }
                            }
                        }
                    }
                    
                    // Budget and timeline
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Budget")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            Text("$\(minBudget) - $\(maxBudget)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#850101"))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Timeline")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            Text(timeline)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            }
            
            // Posting Information
            VStack(alignment: .leading, spacing: 12) {
                Text("What happens next?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                infoItem("Your gig will be visible to creators immediately")
                infoItem("You'll receive applications within 24 hours")
                infoItem("Review profiles and select the best fit")
                infoItem("Start your project with confidence")
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Helper Views
    private func tipItem(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#850101"))
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    private func infoItem(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(.blue)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        VStack(spacing: 0) {
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0),
                    Color.white.opacity(0.8),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 40)
            
            HStack(spacing: 16) {
                if currentStep != .title {
                    ServicesSecondaryButton(title: "Back") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentStep = PostGigStep(rawValue: currentStep.rawValue - 1) ?? .title
                        }
                    }
                    .frame(height: 48)
                }
                
                PrimaryCTAButton(
                    title: currentStep == .review ? "Post Gig" : "Continue",
                    isLoading: isPosting
                ) {
                    if currentStep == .review {
                        postGig()
                    } else {
                        nextStep()
                    }
                }
                .frame(height: 48)
                .disabled(!canContinue)
                .opacity(canContinue ? 1.0 : 0.6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34) // Safe area bottom
            .background(Color.white)
        }
    }
    
    // MARK: - Computed Properties
    private var canContinue: Bool {
        switch currentStep {
        case .title:
            return !gigTitle.isEmpty
        case .description:
            return !gigDescription.isEmpty
        case .categories:
            return !selectedCategories.isEmpty
        case .budget:
            return !minBudget.isEmpty && !maxBudget.isEmpty
        case .timeline:
            return !timeline.isEmpty
        case .deliverables:
            return !deliverables.filter { !$0.isEmpty }.isEmpty
        case .requirements:
            return true // Optional step
        case .review:
            return true
        }
    }
    
    // MARK: - Actions
    private func nextStep() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if let nextStep = PostGigStep(rawValue: currentStep.rawValue + 1) {
                currentStep = nextStep
            }
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func postGig() {
        isPosting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isPosting = false
            
            // Success feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Dismiss modal
            dismiss()
        }
    }
}

// MARK: - Category Selection Chip
struct CategorySelectionChip: View {
    let category: ServiceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(hex: category.color))
                
                Text(category.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color(hex: category.color) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: category.color), lineWidth: isSelected ? 0 : 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Preview
struct PostGigFlow_Previews: PreviewProvider {
    static var previews: some View {
        PostGigFlow()
    }
} 