import SwiftUI

// MARK: - Services Marketplace Hub View
struct ServicesMarketplaceHub: View {
    @State private var selectedMode: MarketplaceMode = .findGigs
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var isSearchActive = false
    
    enum MarketplaceMode: Int, CaseIterable {
        case findGigs = 0
        case findTalent = 1
        
        var title: String {
            switch self {
            case .findGigs:
                return "Gigs"
            case .findTalent:
                return "Talent"
            }
        }
        
        var searchPlaceholder: String {
            switch self {
            case .findGigs:
                return "Search gigs..."
            case .findTalent:
                return "Search talent..."
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section
                headerSection
                
                // Main Content
                mainContent
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                        removal: .opacity.combined(with: .move(edge: .leading))
                    ))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedMode)
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .dismissKeyboardOnBackgroundTap()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 24) {
            // Welcome Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Services")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Where creativity meets opportunity")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Profile Button
                Button(action: {
                    // Handle profile action
                }) {
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.secondary)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Search Bar
            searchBar
            
            // Mode Selector
            modeSelector
        }
        .padding(.bottom, 16)
        .background(Color.white)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                TextField(selectedMode.searchPlaceholder, text: $searchText)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSearchActive = true
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(hex: "#F2F2F7"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSearchActive ? Color(hex: "#850101") : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isSearchActive ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSearchActive)
            
            // Filter Button
            Button(action: {
                showingFilters = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Mode Selector
    private var modeSelector: some View {
        ServicesSegmentedControl(
            selectedSegment: .constant(selectedMode.rawValue),
            segments: MarketplaceMode.allCases.map { $0.title },
            onSelectionChange: { index in
                if let mode = MarketplaceMode(rawValue: index) {
                    selectedMode = mode
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        Group {
            switch selectedMode {
            case .findGigs:
                CreatorGigFeed()
            case .findTalent:
                BusinessTalentFeed()
            }
        }
        .id(selectedMode) // Force view recreation for smooth transitions
    }
}

// MARK: - Creator Gig Feed
struct CreatorGigFeed: View {
    @State private var gigs = ServicesModels.sampleGigs
    @State private var isLoading = false
    @State private var selectedGig: Gig?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                // Featured Section
                featuredSection
                
                // All Gigs
                allGigsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color.white)
        .refreshable {
            await refreshGigs()
        }
        .sheet(item: $selectedGig) { gig in
            GigDetailView(gig: gig)
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    // Handle view all action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#850101"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(gigs.prefix(3)) { gig in
                        ServiceCard(gig: gig) {
                            selectedGig = gig
                        }
                        .frame(width: 300)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var allGigsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(gigs.count) available")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            if isLoading {
                loadingView
            } else if gigs.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(gigs) { gig in
                        ServiceCard(gig: gig) {
                            selectedGig = gig
                        }
                        .onAppear {
                            // Animate card appearance
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                // Animation handled by LazyVStack
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerEffect()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "briefcase.fill",
            title: "No gigs yet",
            description: "New opportunities are posted daily.",
            actionTitle: "Browse Categories",
            action: {
                // Handle browse categories action
            }
        )
    }
    
    private func refreshGigs() async {
        isLoading = true
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

// MARK: - Business Talent Feed
struct BusinessTalentFeed: View {
    @State private var talents = [ServicesModels.sampleTalentProfile]
    @State private var isLoading = false
    @State private var selectedTalent: TalentProfile?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                // Top Talent Section
                topTalentSection
                
                // All Talent
                allTalentSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color.white)
        .refreshable {
            await refreshTalents()
        }
        .sheet(item: $selectedTalent) { talent in
            TalentDetailView(talent: talent)
        }
    }
    
    private var topTalentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    // Handle view all action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#850101"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(talents.prefix(3)) { talent in
                        TalentCard(talent: talent) {
                            selectedTalent = talent
                        }
                        .frame(width: 280)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var allTalentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(talents.count) available")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            if isLoading {
                loadingView
            } else if talents.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(talents) { talent in
                        TalentCard(talent: talent) {
                            selectedTalent = talent
                        }
                    }
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerEffect()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    private var emptyStateView: some View {
        EmptyStateView(
            icon: "person.2.fill",
            title: "No talent yet",
            description: "Discover amazing creators for your next project.",
            actionTitle: "Post a Gig",
            action: {
                // Handle post gig action
            }
        )
    }
    
    private func refreshTalents() async {
        isLoading = true
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

// MARK: - Preview
struct ServicesMarketplaceHub_Previews: PreviewProvider {
    static var previews: some View {
        ServicesMarketplaceHub()
            .preferredColorScheme(.light)
    }
} 