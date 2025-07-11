import SwiftUI
import AVKit

// MARK: - Video Player Component

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var player: AVPlayer?
    @State private var isLoading = true
    @State private var hasError = false
    @State private var showingFullscreen = false
    
    var body: some View {
        ZStack {
            if let player = player, !hasError {
                VideoPlayer(player: player)
                    .background(Color.black)
                    .onAppear {
                        print("🎥 VideoPlayer appeared, starting playback")
                        player.play()
                    }
                    .onTapGesture(count: 2) {
                        print("🎥 Double-tap detected, presenting fullscreen")
                        showingFullscreen = true
                        HapticFeedback.impact(.medium)
                    }
                    .fullScreenCover(isPresented: $showingFullscreen) {
                        FullscreenVideoPlayer(player: player, isPresented: $showingFullscreen)
                            .ignoresSafeArea(.all)
                    }
            } else if isLoading {
                // Loading state
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .overlay(
                        VStack(spacing: DeepRedDesign.Spacing.sm) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.2)
                            
                            Text("Loading video...")
                                .font(DeepRedDesign.Typography.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    )
            } else {
                // Error state
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .overlay(
                        VStack(spacing: DeepRedDesign.Spacing.sm) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("Unable to load video")
                                .font(DeepRedDesign.Typography.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    )
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            cleanupPlayer()
        }
    }
    
    private func setupPlayer() {
        print("🎥 Setting up player for URL: \(videoURL)")
        print("🎥 Video URL exists: \(FileManager.default.fileExists(atPath: videoURL.path))")
        
        let newPlayer = AVPlayer(url: videoURL)
        
        // Configure player for optimal playback and fullscreen
        newPlayer.automaticallyWaitsToMinimizeStalling = false
        newPlayer.allowsExternalPlayback = true
        
        self.player = newPlayer
        
        // Check if video loads successfully and manage states
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if newPlayer.status == .readyToPlay {
                print("🎥 Video is ready to play")
                isLoading = false
                hasError = false
                newPlayer.play()
            } else if newPlayer.status == .failed {
                print("🎥 Video failed to load: \(newPlayer.error?.localizedDescription ?? "Unknown error")")
                isLoading = false
                hasError = true
            } else {
                print("🎥 Video status: \(newPlayer.status.rawValue)")
                // Give it more time to load
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if newPlayer.status == .readyToPlay {
                        print("🎥 Video is ready to play (after delay)")
                        isLoading = false
                        hasError = false
                        newPlayer.play()
                    } else {
                        print("🎥 Video still not ready, showing error")
                        isLoading = false
                        hasError = true
                    }
                }
            }
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
    }
}

// MARK: - Fullscreen Video Player

struct FullscreenVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.allowsPictureInPicturePlayback = true
        controller.showsPlaybackControls = true
        
        // Configure for true fullscreen edge-to-edge presentation
        controller.modalPresentationStyle = .fullScreen
        controller.videoGravity = .resizeAspectFill  // Fill entire screen
        
        // Ensure truly edge-to-edge presentation
        controller.view.backgroundColor = .black
        controller.view.clipsToBounds = true
        
        // Remove any safe area insets to make it truly fullscreen
        controller.edgesForExtendedLayout = .all
        controller.extendedLayoutIncludesOpaqueBars = true
        
        // Add custom double-tap gesture to dismiss
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        controller.view.addGestureRecognizer(doubleTapGesture)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player if needed
        if uiViewController.player != player {
            uiViewController.player = player
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: FullscreenVideoPlayer
        
        init(_ parent: FullscreenVideoPlayer) {
            self.parent = parent
        }
        
        @objc func handleDoubleTap() {
            print("🎥 Double-tap detected in fullscreen, dismissing")
            HapticFeedback.impact(.medium)
            parent.isPresented = false
        }
    }
}

// MARK: - Video Post View

struct VideoPostView: View {
    let videoURL: URL
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var caption = ""
    @State private var isPosting = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DeepRedDesign.Colors.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(DeepRedDesign.Typography.body)
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Spacer()
                        
                        Text("New Post")
                            .font(DeepRedDesign.Typography.bodyBold)
                            .primaryText()
                        
                        Spacer()
                        
                        Button("Post") {
                            postVideo()
                        }
                        .font(DeepRedDesign.Typography.bodyBold)
                        .foregroundColor(isPosting ? DeepRedDesign.Colors.graphite : DeepRedDesign.Colors.accent)
                        .disabled(isPosting)
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    // Video Preview - Native fullscreen enabled
                    VideoPlayerView(videoURL: videoURL)
                        .frame(height: 400)
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    // Caption Input
                    VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                        HStack {
                            Text("Caption")
                                .font(DeepRedDesign.Typography.bodyBold)
                                .primaryText()
                            
                            Spacer()
                            
                            Text("\(caption.count)/500")
                                .font(DeepRedDesign.Typography.caption)
                                .foregroundColor(DeepRedDesign.Colors.graphite)
                        }
                        
                        TextField("Write a caption...", text: $caption, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(DeepRedDesign.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: DeepRedDesign.CornerRadius.button)
                                    .fill(DeepRedDesign.Colors.ash)
                            )
                            .onChange(of: caption) { _, newValue in
                                if newValue.count > 500 {
                                    caption = String(newValue.prefix(500))
                                }
                            }
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    Spacer()
                    
                    // Post Button
                    PrimaryButton(isPosting ? "Posting..." : "Share Video", isEnabled: !isPosting) {
                        postVideo()
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    .padding(.bottom, DeepRedDesign.Spacing.lg)
                }
            }
            .dismissKeyboardOnBackgroundTap()
        }
    }
    
    private func postVideo() {
        guard !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            HapticFeedback.notification(.warning)
            return
        }
        
        isPosting = true
        HapticFeedback.impact(.medium)
        
        // Simulate posting with video processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            HapticFeedback.notification(.success)
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview("Video Post") {
    VideoPostView(videoURL: URL(string: "https://example.com/video.mp4")!) {
        print("Post dismissed")
    }
} 