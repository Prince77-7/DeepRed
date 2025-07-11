import SwiftUI

// MARK: - Home Feed View

struct HomeFeedView: View {
    @StateObject private var appState = AppStateManager()
    @State private var currentVideoIndex = 0
    @State private var showSearch = false
    @State private var showNotifications = false
    @State private var refreshing = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showCameraView = false
    
    private let videos = SampleData.sampleVideos
    private let headerHeight: CGFloat = 60
    
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
                    
                    // Video Feed
                    VideoFeedScrollView(
                        videos: videos,
                        currentIndex: $currentVideoIndex,
                        refreshing: $refreshing,
                        onScrollChanged: { offset in
                            scrollOffset = offset
                        }
                    )
                }
                
                // Dreamy Top Shadow Overlay
                VStack {
                    // Organic shadow gradient that fades naturally
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.25 * scrollProgress), location: 0.0),
                            .init(color: Color.black.opacity(0.20 * scrollProgress), location: 0.1),
                            .init(color: Color.black.opacity(0.12 * scrollProgress), location: 0.25),
                            .init(color: Color.black.opacity(0.06 * scrollProgress), location: 0.45),
                            .init(color: Color.black.opacity(0.02 * scrollProgress), location: 0.65),
                            .init(color: Color.black.opacity(0.005 * scrollProgress), location: 0.8),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    .ignoresSafeArea(.all, edges: .top)
                    .animation(.easeInOut(duration: 0.25), value: scrollProgress)
                    
                    Spacer()
                }
                
                // Floating Record Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingRecordButton {
                            showCameraView = true
                        }
                        .padding(.trailing, DeepRedDesign.Spacing.screenMargin)
                        .padding(.bottom, DeepRedDesign.Spacing.screenMargin) // Seamless positioning above tab bar
                    }
                }
            }
        }

        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
        .fullScreenCover(isPresented: $showCameraView) {
            CameraRecordingView(useBackCamera: false) {
                // Camera will automatically dismiss when done
            }
        }
        .environmentObject(appState)
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
    
    // Scroll progress for dreamy overlay
    private var scrollProgress: Double {
        let threshold: CGFloat = 80
        let progress = min(max(scrollOffset / threshold, 0), 1)
        // Smooth curve for dreamy effect
        return progress * progress * (3.0 - 2.0 * progress)
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
    let videos: [VideoPost]
    @Binding var currentIndex: Int
    @Binding var refreshing: Bool
    let onScrollChanged: (CGFloat) -> Void
    
    @State private var cardPositions: [Int: CGFloat] = [:]
    @State private var scrollViewBounds: CGRect = .zero
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: DeepRedDesign.Spacing.md) {
                    // Pull to refresh indicator
                    if refreshing {
                        RefreshIndicator()
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Video Cards
                    ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                        VideoCard(video: video, allVideos: videos, videoIndex: index)
                            .id(video.id)
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
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                scrollViewBounds = geometry.frame(in: .global)
                            }
                            .onChange(of: geometry.frame(in: .named("scrollView")).minY) { _, newValue in
                                onScrollChanged(-newValue)
                                updateCurrentIndexBasedOnScreenCenter()
                            }
                    }
                )
            }
            .refreshable {
                await refreshFeed()
            }
            .onAppear {
                // Scroll to current video on appear
                if currentIndex < videos.count {
                    proxy.scrollTo(videos[currentIndex].id, anchor: .center)
                }
            }
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
    
    @MainActor
    private func refreshFeed() async {
        refreshing = true
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            refreshing = false
        }
        
        HapticFeedback.notification(.success)
    }
}

// MARK: - Refresh Indicator

struct RefreshIndicator: View {
    @State private var rotation = 0.0
    
    var body: some View {
        VStack(spacing: DeepRedDesign.Spacing.sm) {
            Circle()
                .stroke(DeepRedDesign.Colors.accent, lineWidth: 3)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .fill(DeepRedDesign.Colors.accent)
                        .frame(width: 8, height: 8)
                        .offset(x: 11)
                )
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            
            Text("Refreshing...")
                .font(DeepRedDesign.Typography.caption)
                .foregroundColor(DeepRedDesign.Colors.accent)
        }
        .padding(.vertical, DeepRedDesign.Spacing.md)
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