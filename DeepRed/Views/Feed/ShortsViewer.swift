import SwiftUI
import Foundation

// MARK: - Shorts Viewer

struct ShortsViewer: View {
    let videos: [VideoPost]
    let initialIndex: Int
    @State private var currentIndex: Int
    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning = false
    @State private var isDismissing = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private let videoHeight = UIScreen.main.bounds.height
    
    init(videos: [VideoPost], initialIndex: Int = 0) {
        self.videos = videos
        self.initialIndex = initialIndex
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            // Vertical Video Stack
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                            ShortsVideoView(
                                video: video,
                                isCurrentVideo: index == currentIndex,
                                onDismiss: { 
                                    handleDismiss()
                                }
                            )
                            .frame(height: UIScreen.main.bounds.height)
                            .id(index) // Add ID for scroll targeting
                            .onAppear {
                                currentIndex = index
                            }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .onAppear {
                    // Instantly position at the selected video without animation
                    proxy.scrollTo(initialIndex, anchor: .top)
                }
            }
            .ignoresSafeArea()
        }
        .scaleEffect(isDismissing ? 0.9 : 1.0)
        .opacity(isDismissing ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: isDismissing)
        .onAppear {
            // Ensure we start at the correct index
            if currentIndex != initialIndex {
                currentIndex = initialIndex
            }
        }
        .statusBarHidden()
    }
    
    private func handleDismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDismissing = true
        }
        
        // Delay the actual dismiss to allow animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            dismiss()
        }
    }
}

// MARK: - Shorts Video View

struct ShortsVideoView: View {
    let video: VideoPost
    let isCurrentVideo: Bool
    let onDismiss: () -> Void
    
    @State private var isUpvoted: Bool
    @State private var isDownvoted: Bool
    @State private var upvoteCount: Int
    @State private var downvoteCount: Int
    @State private var showUserProfile = false
    @State private var showComments = false
    @State private var showShare = false
    @State private var upvoteAnimation = false
    @State private var downvoteAnimation = false
    @State private var shareAnimation = false
    @State private var followAnimation = false
    @State private var isPlaying = false
    
    init(video: VideoPost, isCurrentVideo: Bool, onDismiss: @escaping () -> Void) {
        self.video = video
        self.isCurrentVideo = isCurrentVideo
        self.onDismiss = onDismiss
        self._isUpvoted = State(initialValue: video.isLiked)
        self._isDownvoted = State(initialValue: false)
        self._upvoteCount = State(initialValue: video.likeCount)
        self._downvoteCount = State(initialValue: max(1, video.likeCount / 4))
    }
    
    private var totalVotes: Int {
        upvoteCount + downvoteCount
    }
    
    private var upvoteRatio: Double {
        totalVotes > 0 ? Double(upvoteCount) / Double(totalVotes) : 0
    }
    
    private var downvoteRatio: Double {
        totalVotes > 0 ? Double(downvoteCount) / Double(totalVotes) : 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.9),
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.9)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Video Content Area
                ZStack {
                    // Play indicator (when paused)
                    if !isPlaying {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.white)
                                    .offset(x: 3) // Slight offset to center visually
                            )
                            .scaleEffect(isPlaying ? 0.1 : 1.0)
                            .opacity(isPlaying ? 0 : 1)
                            .animation(.easeInOut(duration: 0.3), value: isPlaying)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPlaying.toggle()
                    }
                    HapticFeedback.impact(.light)
                }
                
                // UI Overlay
                VStack(spacing: 0) {
                    // Top area - User info
                    HStack {
                        // User Profile
                        Button(action: {
                            HapticFeedback.impact(.light)
                            showUserProfile = true
                        }) {
                            HStack(spacing: DeepRedDesign.Spacing.xs) {
                                // Profile Picture
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: video.user.profileImageName)
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.black)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                // Display Name Only
                                HStack(spacing: 4) {
                                    Text(video.user.displayName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if video.user.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        // Follow Button
                        Button(action: {
                            HapticFeedback.impact(.medium)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                followAnimation = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                followAnimation = false
                            }
                        }) {
                            Text("Follow")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(DeepRedDesign.Colors.accent)
                                        .shadow(
                                            color: DeepRedDesign.Colors.accent.opacity(0.4),
                                            radius: 8,
                                            x: 0,
                                            y: 4
                                        )
                                )
                        }
                        .scaleEffect(followAnimation ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: followAnimation)
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.top, 60) // Safe area padding for status bar/notch
                    
                    Spacer()
                    
                    // Bottom area - Caption and Actions
                    HStack(alignment: .bottom, spacing: DeepRedDesign.Spacing.md) {
                        // Left side - Caption and metadata
                        VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.sm) {
                            // Caption (one line max)
                            Text(video.caption)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                            
                            // Metadata (view count only)
                            HStack(spacing: 4) {
                                Image(systemName: "eye")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(video.viewCountFormatted)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Right side - Action buttons
                        VStack(spacing: DeepRedDesign.Spacing.lg) {
                            // Upvote Button
                            Button(action: {
                                handleUpvote()
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 2)
                                            .frame(width: 48, height: 48)
                                        
                                        Circle()
                                            .trim(from: 0, to: upvoteRatio)
                                            .stroke(
                                                isUpvoted ? DeepRedDesign.Colors.accent : .white.opacity(0.6),
                                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                            )
                                            .frame(width: 48, height: 48)
                                            .rotationEffect(.degrees(-90))
                                            .animation(.easeInOut(duration: 0.5), value: upvoteRatio)
                                        
                                        Image(systemName: "arrow.up")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(isUpvoted ? DeepRedDesign.Colors.accent : .white)
                                    }
                                    .scaleEffect(upvoteAnimation ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: upvoteAnimation)
                                    
                                    Text(formatCount(upvoteCount))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Downvote Button
                            Button(action: {
                                handleDownvote()
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 2)
                                            .frame(width: 48, height: 48)
                                        
                                        Circle()
                                            .trim(from: 0, to: downvoteRatio)
                                            .stroke(
                                                isDownvoted ? .orange : .white.opacity(0.6),
                                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                            )
                                            .frame(width: 48, height: 48)
                                            .rotationEffect(.degrees(-90))
                                            .animation(.easeInOut(duration: 0.5), value: downvoteRatio)
                                        
                                        Image(systemName: "arrow.down")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(isDownvoted ? .orange : .white)
                                    }
                                    .scaleEffect(downvoteAnimation ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: downvoteAnimation)
                                    
                                    Text(formatCount(downvoteCount))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Comment Button
                            Button(action: {
                                HapticFeedback.impact(.light)
                                showComments = true
                            }) {
                                VStack(spacing: 6) {
                                    Image(systemName: "message.circle")
                                        .font(.system(size: 48, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text(formatCount(video.commentCount))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // Share Button
                            Button(action: {
                                HapticFeedback.impact(.light)
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    shareAnimation = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    shareAnimation = false
                                }
                                
                                showShare = true
                            }) {
                                VStack(spacing: 6) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 48, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text(formatCount(video.shareCount))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .scaleEffect(shareAnimation ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: shareAnimation)
                        }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.bottom, DeepRedDesign.Spacing.xl)
                }
                .background(
                    // Bottom gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .clear,
                            .clear,
                            .black.opacity(0.3),
                            .black.opacity(0.6)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .onAppear {
            // Auto-play when video appears
            if isCurrentVideo {
                isPlaying = true
            }
        }
        .onChange(of: isCurrentVideo) { _, newValue in
            // Auto-play current video, pause others
            withAnimation(.easeInOut(duration: 0.3)) {
                isPlaying = newValue
            }
        }
        .sheet(isPresented: $showUserProfile) {
            UserProfileSheet(user: video.user)
        }
        .sheet(isPresented: $showComments) {
            ShortsCommentsSheet(video: video)
        }
        .sheet(isPresented: $showShare) {
            ShortsShareSheet(video: video)
        }
        .onTapGesture(count: 2) {
            // Double-tap anywhere to go back to home screen
            HapticFeedback.impact(.medium)
            onDismiss()
        }
    }
    
    private func handleUpvote() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            if isUpvoted {
                isUpvoted = false
                upvoteCount = max(0, upvoteCount - 1)
            } else {
                isUpvoted = true
                upvoteCount += 1
                if isDownvoted {
                    isDownvoted = false
                    downvoteCount = max(0, downvoteCount - 1)
                }
            }
            upvoteAnimation = true
        }
        
        HapticFeedback.impact(.medium)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            upvoteAnimation = false
        }
    }
    
    private func handleDownvote() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            if isDownvoted {
                isDownvoted = false
                downvoteCount = max(0, downvoteCount - 1)
            } else {
                isDownvoted = true
                downvoteCount += 1
                if isUpvoted {
                    isUpvoted = false
                    upvoteCount = max(0, upvoteCount - 1)
                }
            }
            downvoteAnimation = true
        }
        
        HapticFeedback.impact(.medium)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            downvoteAnimation = false
        }
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000.0)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        } else {
            return "\(count)"
        }
    }
}

// MARK: - Shorts Comments Sheet

struct ShortsCommentsSheet: View {
    let video: VideoPost
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    Text("Comments")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                
                Divider()
                
                // Comments List Placeholder
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text("Comments")
                        .font(DeepRedDesign.Typography.title1)
                        .foregroundColor(.primary)
                    
                    Text("Comments for this video will appear here")
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                .background(DeepRedDesign.Colors.primaryBackground)
            }
            .background(DeepRedDesign.Colors.primaryBackground)
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Shorts Share Sheet

struct ShortsShareSheet: View {
    let video: VideoPost
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    Text("Share")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                
                Divider()
                
                // Share Options
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                    
                    Text("Share Video")
                        .font(DeepRedDesign.Typography.title1)
                        .foregroundColor(.primary)
                    
                    Text("Share this video with your friends")
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                .background(DeepRedDesign.Colors.primaryBackground)
            }
            .background(DeepRedDesign.Colors.primaryBackground)
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview("Shorts Viewer") {
    ShortsViewer(
        videos: SampleData.sampleVideos,
        initialIndex: 0
    )
} 