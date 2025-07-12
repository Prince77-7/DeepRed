import SwiftUI

// MARK: - Video Card Component

struct VideoCard: View {
    let video: VideoPost
    let allVideos: [VideoPost]
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
    
    init(video: VideoPost, allVideos: [VideoPost] = [], videoIndex: Int = 0) {
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
            CommentsSheet(video: video)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showUserProfile) {
            UserProfileSheet(user: video.user)
        }
        .fullScreenCover(isPresented: $showShortsViewer) {
            ShortsViewer(videos: allVideos.isEmpty ? [video] : allVideos, initialIndex: videoIndex)
                .transition(.opacity)
        }
    }
}

// MARK: - Comments Sheet

struct CommentsSheet: View {
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
                    
                    Text("Comments for this video will appear here")
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