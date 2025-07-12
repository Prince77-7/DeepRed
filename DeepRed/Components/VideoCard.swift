import SwiftUI

// MARK: - Video Card Component

struct VideoCard: View {
    let video: Post
    let allVideos: [Post]
    let videoIndex: Int
    @State private var isUpvoted: Bool
    @State private var isDownvoted: Bool
    @State private var upvoteCount: Int
    @State private var downvoteCount: Int
    @State private var showUserProfile = false
    @State private var showComments = false
    @State private var showShortsViewer = false
    @State private var upvoteAnimation = false
    @State private var downvoteAnimation = false
    @State private var shareAnimation = false
    
    init(video: Post, allVideos: [Post] = [], videoIndex: Int = 0) {
        self.video = video
        self.allVideos = allVideos
        self.videoIndex = videoIndex
        self._isUpvoted = State(initialValue: video.isLiked)
        self._isDownvoted = State(initialValue: false)
        // Sample vote counts - in real app this would come from the video model
        self._upvoteCount = State(initialValue: video.likeCount)
        self._downvoteCount = State(initialValue: max(1, video.likeCount / 4)) // Sample ratio
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
        ZStack {
            // Video Background (Premium gradient overlay)
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.9),
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 520)
                .overlay(
                    // Video Thumbnail Placeholder with subtle play indicator
                    ZStack {
                        // Subtle play button overlay
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            )
                            .scaleEffect(upvoteAnimation ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: upvoteAnimation)
                    }
                )
                .onTapGesture(count: 2) {
                    // Double-tap to open shorts viewer
                    HapticFeedback.impact(.medium)
                    showShortsViewer = true
                }
            
            // Minimal Content Overlay
            VStack {
                // Top Section - Clean User Info
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showUserProfile = true
                        }
                    }) {
                        HStack(spacing: DeepRedDesign.Spacing.xs) {
                            // Profile Picture
                            Circle()
                                .fill(DeepRedDesign.Colors.snow)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: video.user.profileImageName)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.onyx)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(spacing: 3) {
                                    Text(video.user.displayName)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if video.user.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text("@\(video.user.username)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Premium Collaborate Button
                    Button(action: {
                        HapticFeedback.impact(.medium)
                    }) {
                        Text("Collaborate")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(DeepRedDesign.Colors.accent)
                                    .shadow(color: DeepRedDesign.Colors.accent.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                    }
                    .scaleEffect(shareAnimation ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: shareAnimation)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.top, DeepRedDesign.Spacing.sm)
                
                Spacer()
                
                // Bottom Section - Minimal Action Bar
                HStack {
                    // Left side - Interaction buttons
                    HStack(spacing: DeepRedDesign.Spacing.md) {
                        // Upvote Button with proportional fill
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    // Background circle
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    // Proportional fill
                                    Circle()
                                        .trim(from: 0, to: upvoteRatio)
                                        .stroke(
                                            isUpvoted ? DeepRedDesign.Colors.accent : .white.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: upvoteRatio)
                                    
                                    // Arrow icon
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isUpvoted ? DeepRedDesign.Colors.accent : .white)
                                }
                                .scaleEffect(upvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: upvoteAnimation)
                                
                                Text("\(upvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        // Downvote Button with proportional fill
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    // Background circle
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    // Proportional fill
                                    Circle()
                                        .trim(from: 0, to: downvoteRatio)
                                        .stroke(
                                            isDownvoted ? .orange : .white.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: downvoteRatio)
                                    
                                    // Arrow icon
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isDownvoted ? .orange : .white)
                                }
                                .scaleEffect(downvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: downvoteAnimation)
                                
                                Text("\(downvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        // Comment Button
                        Button(action: {
                            HapticFeedback.impact(.light)
                            showComments = true
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: "message.circle")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("\(video.commentCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Right side - Clean view count
                    VStack(spacing: 4) {
                        Image(systemName: "eye")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(video.viewCountFormatted)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.bottom, DeepRedDesign.Spacing.sm)
                .background(
                    // Subtle gradient overlay for action bar
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .black.opacity(0.1),
                            .black.opacity(0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .sheet(isPresented: $showComments) {
            CommentsSheet(post: video)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showUserProfile) {
            UserProfileSheet(user: video.user)
        }
        .fullScreenCover(isPresented: $showShortsViewer) {
            ShortsViewer(videos: allVideos.isEmpty ? [video] : allVideos, initialIndex: videoIndex)
        }
    }
}

// MARK: - Text Card Component

struct TextCard: View {
    let post: Post
    let allPosts: [Post]
    let postIndex: Int
    @State private var isUpvoted: Bool
    @State private var isDownvoted: Bool
    @State private var upvoteCount: Int
    @State private var downvoteCount: Int
    @State private var showUserProfile = false
    @State private var showComments = false
    @State private var upvoteAnimation = false
    @State private var downvoteAnimation = false
    @State private var shareAnimation = false
    @State private var isExpanded = false
    
    private let maxCollapsedLines = 5
    
    init(post: Post, allPosts: [Post] = [], postIndex: Int = 0) {
        self.post = post
        self.allPosts = allPosts
        self.postIndex = postIndex
        self._isUpvoted = State(initialValue: post.isLiked)
        self._isDownvoted = State(initialValue: false)
        self._upvoteCount = State(initialValue: post.likeCount)
        self._downvoteCount = State(initialValue: max(1, post.likeCount / 4))
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
    
    private var textContent: String {
        post.content.textContent ?? ""
    }
    
    private var shouldShowReadMore: Bool {
        // For simplicity, assume longer text needs read more - will be refined based on actual text
        textContent.count > 200 // Rough estimation for 5 lines
    }
    
    var body: some View {
        ZStack {
            // Elegant Text Background with Subtle Gradient
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DeepRedDesign.Colors.snow,
                            DeepRedDesign.Colors.snow.opacity(0.98),
                            DeepRedDesign.Colors.ash.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    DeepRedDesign.Colors.ash.opacity(0.3),
                                    DeepRedDesign.Colors.ash.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )

            
            // Content Layout
            VStack(spacing: 0) {
                // Top Section - Clean User Info
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showUserProfile = true
                        }
                    }) {
                        HStack(spacing: DeepRedDesign.Spacing.xs) {
                            // Profile Picture
                            Circle()
                                .fill(DeepRedDesign.Colors.ash)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: post.user.profileImageName)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.onyx)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(spacing: 3) {
                                    Text(post.user.displayName)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(DeepRedDesign.Colors.onyx)
                                    
                                    if post.user.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text("@\(post.user.username)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(DeepRedDesign.Colors.graphite)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Premium Collaborate Button
                    Button(action: {
                        HapticFeedback.impact(.medium)
                        shareAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            shareAnimation = false
                        }
                    }) {
                        Text("Collaborate")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(DeepRedDesign.Colors.accent)
                                    .shadow(color: DeepRedDesign.Colors.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                    .scaleEffect(shareAnimation ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: shareAnimation)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.top, DeepRedDesign.Spacing.sm)
                
                // Text Content Section - Clean and Simple
                VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                    // Text content
                    Text(textContent)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(DeepRedDesign.Colors.onyx)
                        .lineLimit(isExpanded ? nil : maxCollapsedLines)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, DeepRedDesign.Spacing.sm)
                        .padding(.vertical, DeepRedDesign.Spacing.sm)
                    
                    // Read More/Less Button
                    if shouldShowReadMore {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                            }
                            HapticFeedback.impact(.light)
                        }) {
                            Text(isExpanded ? "Read Less" : "Read More")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DeepRedDesign.Colors.accent)
                                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                        }
                        .padding(.bottom, DeepRedDesign.Spacing.xs)
                    }
                }
                
                Spacer()
                
                // Bottom Section - Minimal Action Bar
                HStack {
                    // Left side - Interaction buttons
                    HStack(spacing: DeepRedDesign.Spacing.md) {
                        // Upvote Button
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .stroke(DeepRedDesign.Colors.graphite.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    Circle()
                                        .trim(from: 0, to: upvoteRatio)
                                        .stroke(
                                            isUpvoted ? Color.green.opacity(0.8) : DeepRedDesign.Colors.graphite.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: upvoteRatio)
                                    
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isUpvoted ? Color.green.opacity(0.8) : DeepRedDesign.Colors.graphite)
                                }
                                .scaleEffect(upvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: upvoteAnimation)
                                
                                Text("\(upvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(DeepRedDesign.Colors.onyx)
                            }
                        }
                        
                        // Downvote Button
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .stroke(DeepRedDesign.Colors.graphite.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    Circle()
                                        .trim(from: 0, to: downvoteRatio)
                                        .stroke(
                                            isDownvoted ? .red : DeepRedDesign.Colors.graphite.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: downvoteRatio)
                                    
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isDownvoted ? .red : DeepRedDesign.Colors.graphite)
                                }
                                .scaleEffect(downvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: downvoteAnimation)
                                
                                Text("\(downvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(DeepRedDesign.Colors.onyx)
                            }
                        }
                        
                        // Comment Button
                        Button(action: {
                            HapticFeedback.impact(.light)
                            showComments = true
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: "message.circle")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(DeepRedDesign.Colors.graphite)
                                
                                Text("\(post.commentCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(DeepRedDesign.Colors.onyx)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Right side - Views count
                    VStack(spacing: 4) {
                        Image(systemName: "eye")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Text(post.viewCountFormatted)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(DeepRedDesign.Colors.graphite)
                    }
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.bottom, DeepRedDesign.Spacing.sm)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        .sheet(isPresented: $showComments) {
            CommentsSheet(post: post)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showUserProfile) {
            UserProfileSheet(user: post.user)
        }
    }
}

// MARK: - Image Card Component

struct ImageCard: View {
    let post: Post
    let allPosts: [Post]
    let postIndex: Int
    @State private var isUpvoted: Bool
    @State private var isDownvoted: Bool
    @State private var upvoteCount: Int
    @State private var downvoteCount: Int
    @State private var showUserProfile = false
    @State private var showComments = false
    @State private var upvoteAnimation = false
    @State private var downvoteAnimation = false
    @State private var shareAnimation = false
    @State private var showImageViewer = false
    
    init(post: Post, allPosts: [Post] = [], postIndex: Int = 0) {
        self.post = post
        self.allPosts = allPosts
        self.postIndex = postIndex
        self._isUpvoted = State(initialValue: post.isLiked)
        self._isDownvoted = State(initialValue: false)
        self._upvoteCount = State(initialValue: post.likeCount)
        self._downvoteCount = State(initialValue: max(1, post.likeCount / 4))
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
        ZStack {
            // Image Background with Gradient Overlay
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DeepRedDesign.Colors.ash.opacity(0.3),
                            DeepRedDesign.Colors.ash.opacity(0.1),
                            DeepRedDesign.Colors.snow
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 520)
                .overlay(
                    // Image Placeholder with elegant styling
                    ZStack {
                        Rectangle()
                            .fill(DeepRedDesign.Colors.ash.opacity(0.2))
                            .overlay(
                                VStack(spacing: DeepRedDesign.Spacing.sm) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 48, weight: .light))
                                        .foregroundColor(DeepRedDesign.Colors.graphite)
                                    
                                    if let imageCaption = post.content.imageCaption {
                                        Text(imageCaption)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(DeepRedDesign.Colors.graphite)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, DeepRedDesign.Spacing.md)
                                    }
                                }
                            )
                        

                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                .onTapGesture {
                    HapticFeedback.impact(.medium)
                    showImageViewer = true
                }
            
            // Content Overlay
            VStack {
                // Top Section - Clean User Info
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showUserProfile = true
                        }
                    }) {
                        HStack(spacing: DeepRedDesign.Spacing.xs) {
                            // Profile Picture
                            Circle()
                                .fill(DeepRedDesign.Colors.snow)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: post.user.profileImageName)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(DeepRedDesign.Colors.onyx)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                HStack(spacing: 3) {
                                    Text(post.user.displayName)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if post.user.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                Text("@\(post.user.username)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Premium Collaborate Button
                    Button(action: {
                        HapticFeedback.impact(.medium)
                        shareAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            shareAnimation = false
                        }
                    }) {
                        Text("Collaborate")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(DeepRedDesign.Colors.accent)
                                    .shadow(color: DeepRedDesign.Colors.accent.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                    }
                    .scaleEffect(shareAnimation ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: shareAnimation)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.top, DeepRedDesign.Spacing.sm)
                
                Spacer()
                
                // Bottom Section - Minimal Action Bar
                HStack {
                    // Left side - Interaction buttons
                    HStack(spacing: DeepRedDesign.Spacing.md) {
                        // Upvote Button
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    Circle()
                                        .trim(from: 0, to: upvoteRatio)
                                        .stroke(
                                            isUpvoted ? Color.green.opacity(0.8) : .white.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: upvoteRatio)
                                    
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isUpvoted ? Color.green.opacity(0.8) : .white)
                                }
                                .scaleEffect(upvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: upvoteAnimation)
                                
                                Text("\(upvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        // Downvote Button
                        Button(action: {
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
                        }) {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 2)
                                        .frame(width: 32, height: 32)
                                    
                                    Circle()
                                        .trim(from: 0, to: downvoteRatio)
                                        .stroke(
                                            isDownvoted ? .red : .white.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                                        )
                                        .frame(width: 32, height: 32)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.5), value: downvoteRatio)
                                    
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(isDownvoted ? .red : .white)
                                }
                                .scaleEffect(downvoteAnimation ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: downvoteAnimation)
                                
                                Text("\(downvoteCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        // Comment Button
                        Button(action: {
                            HapticFeedback.impact(.light)
                            showComments = true
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: "message.circle")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("\(post.commentCount)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, DeepRedDesign.Spacing.sm)
                .padding(.bottom, DeepRedDesign.Spacing.sm)
                .background(
                    // Subtle gradient overlay for action bar
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .black.opacity(0.1),
                            .black.opacity(0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .sheet(isPresented: $showComments) {
            CommentsSheet(post: post)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showUserProfile) {
            UserProfileSheet(user: post.user)
        }
        .fullScreenCover(isPresented: $showImageViewer) {
            ImageViewerSheet(post: post)
        }
    }
}

// MARK: - Image Viewer Sheet

struct ImageViewerSheet: View {
    let post: Post
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    private let dismissThreshold: CGFloat = 150
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    // Close Button (optional - user can now swipe down)
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .background(Color.black.opacity(0.3))
                                )
                        }
                        .padding(.leading, DeepRedDesign.Spacing.screenMargin)
                        .opacity(isDragging ? 0.3 : 1.0) // Fade out during drag
                        
                        Spacer()
                    }
                    .padding(.top, DeepRedDesign.Spacing.screenMargin)
                    
                    Spacer()
                    
                    // Image Content with Native Scroll-to-Dismiss
                    Rectangle()
                        .fill(DeepRedDesign.Colors.ash.opacity(0.2))
                        .overlay(
                            VStack(spacing: DeepRedDesign.Spacing.md) {
                                Image(systemName: "photo")
                                    .font(.system(size: 80, weight: .light))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                if let imageCaption = post.content.imageCaption {
                                    Text(imageCaption)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, DeepRedDesign.Spacing.lg)
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                        .scaleEffect(isDragging ? max(0.8, 1.0 - abs(dragOffset.height) / 1000.0) : 1.0)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    
                                    // Only allow downward scrolling to dismiss
                                    if value.translation.height > 0 {
                                        dragOffset = CGSize(
                                            width: value.translation.width * 0.1, // Slight horizontal movement
                                            height: value.translation.height
                                        )
                                    }
                                }
                                .onEnded { value in
                                    isDragging = false
                                    
                                    // Dismiss if dragged down far enough
                                    if value.translation.height > dismissThreshold {
                                        dismiss()
                                    } else {
                                        // Spring back to original position
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                    
                    Spacer()
                }
                
                // Background dimming during drag
                Color.black
                    .opacity(isDragging ? max(0.3, 1.0 - abs(dragOffset.height) / 300.0) : 0)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isDragging)
    }
}

// MARK: - Updated Comments Sheet

struct CommentsSheet: View {
    let post: Post
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
                        .primaryText()
                    
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
                        .primaryText()
                    
                    Text("Comments for this post will appear here")
                        .font(DeepRedDesign.Typography.body)
                        .secondaryText()
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                .primaryBackground()
            }
            .primaryBackground()
        }
    }
}

// MARK: - User Profile Sheet

struct UserProfileSheet: View {
    let user: User
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
                    
                    Text("Profile")
                        .font(DeepRedDesign.Typography.bodyBold)
                        .primaryText()
                    
                    Spacer()
                    
                    Button("Collaborate") {
                        // Handle collaborate
                    }
                    .foregroundColor(DeepRedDesign.Colors.accent)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.vertical, DeepRedDesign.Spacing.sm)
                
                Divider()
                
                // Profile Content
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Profile Picture
                    Circle()
                        .fill(DeepRedDesign.Colors.ash)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: user.profileImageName)
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(DeepRedDesign.Colors.graphite)
                        )
                    
                    VStack(spacing: DeepRedDesign.Spacing.sm) {
                        HStack(spacing: DeepRedDesign.Spacing.xs) {
                            Text(user.displayName)
                                .font(DeepRedDesign.Typography.title1)
                                .primaryText()
                            
                            if user.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Text("@\(user.username)")
                            .font(DeepRedDesign.Typography.body)
                            .secondaryText()
                        
                        Text(user.bio)
                            .font(DeepRedDesign.Typography.body)
                            .primaryText()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DeepRedDesign.Spacing.md)
                        
                        // Stats
                        HStack(spacing: DeepRedDesign.Spacing.lg) {
                            VStack(spacing: 4) {
                                Text(user.followerCountFormatted)
                                    .font(DeepRedDesign.Typography.bodyBold)
                                    .primaryText()
                                
                                Text("Collaborators")
                                    .font(DeepRedDesign.Typography.caption)
                                    .secondaryText()
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(user.followingCount)")
                                    .font(DeepRedDesign.Typography.bodyBold)
                                    .primaryText()
                                
                                Text("Collaborating")
                                    .font(DeepRedDesign.Typography.caption)
                                    .secondaryText()
                            }
                            
                            VStack(spacing: 4) {
                                Text("\(user.videoCount)")
                                    .font(DeepRedDesign.Typography.bodyBold)
                                    .primaryText()
                                
                                Text("Videos")
                                    .font(DeepRedDesign.Typography.caption)
                                    .secondaryText()
                            }
                        }
                        .padding(.top, DeepRedDesign.Spacing.sm)
                    }
                }
                .padding(.top, DeepRedDesign.Spacing.xl)
                
                Spacer()
            }
            .primaryBackground()
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview("Video Card") {
    VideoCard(video: SampleData.sampleVideos[0], allVideos: SampleData.sampleVideos, videoIndex: 0)
        .padding()
        .primaryBackground()
} 