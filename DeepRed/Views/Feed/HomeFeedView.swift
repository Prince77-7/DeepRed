import SwiftUI

// MARK: - Home Feed View

struct HomeFeedView: View {
    @StateObject private var appState = AppStateManager()
    @State private var currentVideoIndex = 0
    @State private var showSearch = false
    @State private var showNotifications = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showCameraView = false
    @State private var isRefreshing = false
    
    // Pull-to-search state
    @State private var pullToSearchOffset: CGFloat = 0
    @State private var showPullToSearch = false
    @State private var pullToSearchText = ""
    @FocusState private var isPullToSearchFocused: Bool
    
    // Refresh trigger from tab bar
    @Binding private var refreshTrigger: Bool
    
    private let posts = SampleData.sampleVideos
    private let headerHeight: CGFloat = 60
    private let maxPullOffset: CGFloat = 100 // Threshold for pull-to-search activation
    
    init(refreshTrigger: Binding<Bool> = .constant(false)) {
        self._refreshTrigger = refreshTrigger
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 0) {
                    // Native Header with proper layout management
                    AnimatedHeader(
                        showSearch: $showSearch,
                        showNotifications: $showNotifications,
                        scrollOffset: scrollOffset
                    )
                    .frame(height: headerHeight * headerOpacity)
                    .offset(y: headerOffset)
                    .clipped()
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: headerOffset)
                    
                    // Mixed Content Feed with Pull-to-Search
                    VideoFeedScrollView(
                        videos: posts,
                        currentIndex: $currentVideoIndex,
                        pullToSearchOffset: $pullToSearchOffset,
                        showPullToSearch: $showPullToSearch,
                        maxPullOffset: maxPullOffset,
                        refreshTrigger: refreshTrigger,
                        onScrollChanged: { offset in
                            scrollOffset = offset
                        }
                    )
                }
                
                // Pull-to-Search Indicator
                if !showPullToSearch && pullToSearchOffset > 0 {
                    PullToSearchIndicator(
                        offset: pullToSearchOffset,
                        maxOffset: maxPullOffset
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .offset(y: max(0, pullToSearchOffset - 40))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: pullToSearchOffset)
                }
                
                // Dark Mode Search Overlay
                if showPullToSearch {
                    PullToSearchOverlay(
                        searchText: $pullToSearchText,
                        onDismiss: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showPullToSearch = false
                                pullToSearchText = ""
                                pullToSearchOffset = 0
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                }
                
                // Adaptive Fading Overlay - appears when header disappears
                if scrollProgress > 0.1 {
                    VStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask {
                                // Create soft fade that disappears before hitting frame edge
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .black, location: 0.0),
                                        .init(color: .black.opacity(0.95), location: 0.1),
                                        .init(color: .black.opacity(0.85), location: 0.2),
                                        .init(color: .black.opacity(0.7), location: 0.3),
                                        .init(color: .black.opacity(0.5), location: 0.45),
                                        .init(color: .black.opacity(0.3), location: 0.6),
                                        .init(color: .black.opacity(0.15), location: 0.75),
                                        .init(color: .black.opacity(0.05), location: 0.85),
                                        .init(color: .clear, location: 0.95),
                                        .init(color: .clear, location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                            .frame(height: 120)
                            .ignoresSafeArea(.all, edges: .top)
                            .opacity(scrollProgress)
                            .animation(.easeInOut(duration: 0.3), value: scrollProgress)
                        
                        Spacer()
                    }
                    .transition(.opacity)
                }
                
                // Floating Record Button - Hidden (now using tab bar record button)
                // VStack {
                //     Spacer()
                //     HStack {
                //         Spacer()
                //         FloatingRecordButton {
                //             showCameraView = true
                //         }
                //         .padding(.trailing, DeepRedDesign.Spacing.screenMargin)
                //         .padding(.bottom, DeepRedDesign.Spacing.screenMargin) // Seamless positioning above tab bar
                //     }
                // }
                
                // Refresh Indicator Overlay
                if isRefreshing {
                    VStack {
                        HStack {
                            Spacer()
                            RefreshToastView()
                                .padding(.trailing, DeepRedDesign.Spacing.screenMargin)
                                .padding(.top, 100) // Position below header
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isRefreshing)
                }
            }
        }

        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
        // .fullScreenCover(isPresented: $showCameraView) {
        //     CameraRecordingView(useBackCamera: false) {
        //         // Camera will automatically dismiss when done
        //     }
        // }
        .environmentObject(appState)
        .onChange(of: refreshTrigger) { _, _ in
            // Triggered by double-tap on home tab
            performRefresh()
        }
    }
    
    // MARK: - Helper Functions
    
    private func performRefresh() {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        // Reset video index to top immediately for better UX
        currentVideoIndex = 0
        
        // Simulate network delay for refresh completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isRefreshing = false
            }
            
            // Success haptic feedback
            HapticFeedback.notification(.success)
        }
    }
    
    // Native header offset calculation
    private var headerOffset: CGFloat {
        let threshold: CGFloat = 60
        let progress = min(max(scrollOffset / threshold, 0), 1)
        // Use easeInOut curve for smoother transitions
        let easedProgress = progress * progress * (3.0 - 2.0 * progress)
        return -easedProgress * headerHeight
    }
    
    // Native header opacity calculation
    private var headerOpacity: Double {
        let threshold: CGFloat = 60
        let progress = min(max(scrollOffset / threshold, 0), 1)
        let easedProgress = progress * progress * (3.0 - 2.0 * progress)
        return 1.0 - easedProgress
    }
    
    // Scroll progress for adaptive overlay
    private var scrollProgress: Double {
        let threshold: CGFloat = 80
        let progress = min(max(scrollOffset / threshold, 0), 1)
        // Smooth curve for overlay effect
        return progress * progress * (3.0 - 2.0 * progress)
    }
}

// MARK: - Pull-to-Search Indicator

struct PullToSearchIndicator: View {
    let offset: CGFloat
    let maxOffset: CGFloat
    
    @State private var rotationAngle: Double = 0
    
    private var progress: CGFloat {
        min(offset / maxOffset, 1.0)
    }
    
    private var circleSize: CGFloat {
        min(offset / 2, 40)
    }
    
    private var isActivated: Bool {
        progress >= 0.8
    }
    
    var body: some View {
        VStack {
            if offset > 10 {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isActivated ? Color.white : Color.gray.opacity(0.8),
                                isActivated ? Color.gray.opacity(0.1) : Color.gray.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .stroke(
                                isActivated ? Color.white.opacity(0.5) : Color.gray.opacity(0.3),
                                lineWidth: 2
                            )
                    )
                    .overlay(
                        Group {
                            if offset > 30 {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: min(circleSize * 0.4, 16), weight: .semibold))
                                    .foregroundColor(
                                        isActivated ? Color.black : Color.gray.opacity(0.7)
                                    )
                                    .scaleEffect(min(1.0, (offset - 30) / 30))
                                    .rotationEffect(.degrees(rotationAngle))
                            }
                        }
                    )
                    .shadow(
                        color: isActivated ? Color.white.opacity(0.3) : Color.black.opacity(0.1),
                        radius: isActivated ? 8 : 4,
                        x: 0,
                        y: 2
                    )
                    .scaleEffect(isActivated ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActivated)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: circleSize)
                    .onChange(of: isActivated) { _, newValue in
                        if newValue {
                            withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                                rotationAngle = 360
                            }
                            HapticFeedback.impact(.medium)
                        }
                    }
                    .padding(.top, 60)
            }
            Spacer()
        }
    }
}

// MARK: - Pull-to-Search Overlay

struct PullToSearchOverlay: View {
    @Binding var searchText: String
    @FocusState private var isSearchFocused: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Native dreamy background with subtle blur
            Rectangle()
                .fill(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.1),
                            Color.gray.opacity(0.05),
                            Color.white.opacity(0.15)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Search Field
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        TextField("Search creators, videos...", text: $searchText)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(DeepRedDesign.Colors.onyx)
                            .focused($isSearchFocused)
                            .textFieldStyle(PlainTextFieldStyle())
                            .submitLabel(.search)
                            .onSubmit {
                                // Handle search submission
                                performSearch()
                            }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.regularMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Cancel Button
                    Button(action: {
                        // Dismiss keyboard immediately
                        isSearchFocused = false
                        // Then dismiss the overlay
                        onDismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(.thinMaterial)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
                
                Spacer()
            }
        }
        .onAppear {
            // Auto-focus search field with slight delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isSearchFocused = true
            }
        }
    }
    
    private func performSearch() {
        // Implement search logic here
        HapticFeedback.impact(.light)
        onDismiss()
    }
}

// MARK: - Animated Header

struct AnimatedHeader: View {
    @Binding var showSearch: Bool
    @Binding var showNotifications: Bool
    let scrollOffset: CGFloat
    
    @State private var logoRotation = 0.0
    @State private var notificationPulse = false
    @State private var isSearchExpanded = false
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    // Native opacity calculation - synchronized with header offset
    private var headerOpacity: Double {
        let threshold: CGFloat = 60 // Match header offset threshold
        let progress = min(max(scrollOffset / threshold, 0), 1)
        // Use same easeInOut curve for consistent animation
        let easedProgress = progress * progress * (3.0 - 2.0 * progress)
        return 1.0 - easedProgress
    }
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.sm) {
            if isSearchExpanded {
                // Expanded Search Mode
                HStack(spacing: DeepRedDesign.Spacing.sm) {
                    // Search Field
                    HStack(spacing: DeepRedDesign.Spacing.xs) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        TextField("Search creators, videos...", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(DeepRedDesign.Colors.onyx)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isSearchFocused)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(DeepRedDesign.Colors.ash)
                    )
                    .transition(.scale.combined(with: .opacity))
                    
                    // Cancel Button
                    Button("Cancel") {
                        isSearchFocused = false
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isSearchExpanded = false
                            searchText = ""
                        }
                        HapticFeedback.impact(.light)
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DeepRedDesign.Colors.onyx)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
                .transition(.slide)
            } else {
                // Collapsed Normal Mode
                // Logo with subtle animation
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        logoRotation += 360
                    }
                    HapticFeedback.impact(.light)
                }) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 28)
                        .rotationEffect(.degrees(logoRotation))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: logoRotation)
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: DeepRedDesign.Spacing.sm) {
                    // Search Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isSearchExpanded = true
                        }
                        // Auto-focus after animation starts
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isSearchFocused = true
                        }
                        HapticFeedback.impact(.light)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.onyx)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(DeepRedDesign.Colors.snow)
                                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                            )
                    }
                    
                    // Notifications Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showNotifications = true
                            notificationPulse = true
                        }
                        HapticFeedback.impact(.light)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            notificationPulse = false
                        }
                    }) {
                        ZStack {
                            Image(systemName: "bell")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.onyx)
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(DeepRedDesign.Colors.snow)
                                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                                )
                                .scaleEffect(notificationPulse ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: notificationPulse)
                            
                            // Notification Badge
                            Circle()
                                .fill(DeepRedDesign.Colors.accent)
                                .frame(width: 10, height: 10)
                                .overlay(
                                    Text("3")
                                        .font(.system(size: 7, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 10, y: -10)
                                .scaleEffect(notificationPulse ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: notificationPulse)
                        }
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
        .padding(.vertical, DeepRedDesign.Spacing.xs)
        .background(Color.white)
        .opacity(headerOpacity)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: headerOpacity)
        .dismissKeyboardOnBackgroundTap()
    }
}

// MARK: - Video Feed Scroll View

struct VideoFeedScrollView: View {
    let videos: [Post]
    @Binding var currentIndex: Int
    @Binding var pullToSearchOffset: CGFloat
    @Binding var showPullToSearch: Bool
    let maxPullOffset: CGFloat
    let refreshTrigger: Bool
    let onScrollChanged: (CGFloat) -> Void
    
    @State private var cardPositions: [Int: CGFloat] = [:]
    @State private var scrollViewBounds: CGRect = .zero
    @State private var isDragging = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: DeepRedDesign.Spacing.md) {
                    // Mixed Content Cards
                    ForEach(Array(videos.enumerated()), id: \.element.id) { index, post in
                        Group {
                            switch post.contentType {
                            case .video:
                                VideoCard(video: post, allVideos: videos, videoIndex: index)
                            case .text:
                                TextCard(post: post, allPosts: videos, postIndex: index)
                            case .image:
                                ImageCard(post: post, allPosts: videos, postIndex: index)
                            }
                        }
                        .id(post.id)
                        .scaleEffect(getScaleEffect(for: index))
                        .opacity(getOpacity(for: index))
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: currentIndex)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        updateCardPosition(index: index, geometry: geometry)
                                    }
                                    .onChange(of: geometry.frame(in: .named("scrollView")).midY) { _, newValue in
                                        updateCardPosition(index: index, geometry: geometry)
                                    }
                            }
                        )
                    }
                    
                    // Loading more indicator
                    if videos.count > 0 {
                        LoadingIndicator()
                            .padding(.vertical, DeepRedDesign.Spacing.lg)
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.top, max(0, pullToSearchOffset))
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                scrollViewBounds = geometry.frame(in: .global)
                            }
                            .onChange(of: geometry.frame(in: .named("scrollView")).minY) { _, newValue in
                                let offset = -newValue
                                onScrollChanged(offset)
                                updateCurrentIndexBasedOnScreenCenter()
                                
                                // Handle pull-to-search gesture
                                if offset < 0 && !showPullToSearch {
                                    pullToSearchOffset = min(abs(offset), maxPullOffset)
                                } else if !isDragging {
                                    pullToSearchOffset = 0
                                }
                            }
                    }
                )
            }
                            .onAppear {
                    // Scroll to current video on appear
                    if currentIndex < videos.count {
                        proxy.scrollTo(videos[currentIndex].id, anchor: .center)
                    }
                }
                .onChange(of: refreshTrigger) { _, _ in
                    // Scroll to top when refresh is triggered
                    if !videos.isEmpty {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            proxy.scrollTo(videos[0].id, anchor: .top)
                        }
                    }
                }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        
                        // Only handle downward pulls at the top
                        if value.translation.height > 0 && scrollViewBounds.minY >= 0 {
                            pullToSearchOffset = min(value.translation.height * 0.6, maxPullOffset)
                        }
                    }
                    .onEnded { value in
                        isDragging = false
                        
                        if pullToSearchOffset >= maxPullOffset * 0.8 {
                            // Activate pull-to-search
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showPullToSearch = true
                            }
                            HapticFeedback.impact(.medium)
                        } else {
                            // Reset pull indicator
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                pullToSearchOffset = 0
                            }
                        }
                    }
            )
            .coordinateSpace(name: "scrollView")
        }
    }
    
    private func updateCardPosition(index: Int, geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        let newMidY = frame.midY
        
        // Only update if position changed by more than 1pt to reduce unnecessary updates
        if let currentMidY = cardPositions[index] {
            if abs(newMidY - currentMidY) > 1.0 {
                cardPositions[index] = newMidY
            }
        } else {
            cardPositions[index] = newMidY
        }
    }
    
    private func updateCurrentIndexBasedOnScreenCenter() {
        guard !cardPositions.isEmpty else { return }
        
        // Get the actual device screen center Y position
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else { return }
        
        let deviceScreenCenter = window.bounds.height / 2
        
        // Find the card whose center is closest to the actual device screen center
        var bestIndex = currentIndex
        var smallestDistance = CGFloat.greatestFiniteMagnitude
        
        for (index, cardCenterY) in cardPositions {
            let distance = abs(cardCenterY - deviceScreenCenter)
            
            if distance < smallestDistance {
                smallestDistance = distance
                bestIndex = index
            }
        }
        
        // Update current index if we found a closer card
        if bestIndex != currentIndex {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                currentIndex = bestIndex
            }
        }
    }
    
    private func getScaleEffect(for index: Int) -> CGFloat {
        let distance = abs(index - currentIndex)
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return 0.96
        } else {
            return 0.92
        }
    }
    
    private func getOpacity(for index: Int) -> Double {
        let distance = abs(index - currentIndex)
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return 0.8
        } else {
            return 0.6
        }
    }
    

}



// MARK: - Refresh Toast View

struct RefreshToastView: View {
    @State private var rotation = 0.0
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.xs) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            
            Text("Refreshing...")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.6))
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Loading Indicator

struct LoadingIndicator: View {
    @State private var pulse = false
    
    var body: some View {
        HStack(spacing: DeepRedDesign.Spacing.xs) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(DeepRedDesign.Colors.accent)
                    .frame(width: 8, height: 8)
                    .scaleEffect(pulse ? 1.2 : 0.8)
                    .opacity(pulse ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: pulse
                    )
            }
        }
        .onAppear {
            pulse = true
        }
    }
}

// MARK: - Search View

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Spacer()
                    
                    Text("Search")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .primaryText()
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                
                // Search Bar
                DeepRedTextField(
                    title: "",
                    placeholder: "Search creators, videos, or topics...",
                    text: $searchText,
                    keyboardType: .webSearch
                )
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                
                Divider()
                
                // Search Results Placeholder
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text("Search DeepRed")
                        .font(DeepRedDesign.Typography.title1)
                        .primaryText()
                    
                    Text("Find creators, videos, and opportunities")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                .primaryBackground()
            }
            .primaryBackground()
            .dismissKeyboardOnBackgroundTap()
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Notifications View

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .primaryText()
                    
                    Spacer()
                    
                    Button("Mark All Read") {
                        // Handle mark all read
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                    .font(DeepRedDesign.Typography.caption)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                
                Divider()
                
                // Notifications List Placeholder
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text("You're All Caught Up!")
                        .font(DeepRedDesign.Typography.title1)
                        .primaryText()
                    
                    Text("New notifications will appear here")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                .primaryBackground()
            }
            .primaryBackground()
        }
        .presentationDragIndicator(.visible)
    }
}



// MARK: - Preview

#Preview("Home Feed") {
    HomeFeedView()
} 