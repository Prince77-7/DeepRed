import SwiftUI

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
                        .foregroundColor(DeepRedDesign.Colors.graphite)
                        
                        Spacer()
                        
                        Text("New Post")
                            .font(DeepRedDesign.Typography.bodyBold)
                            .primaryText()
                        
                        Spacer()
                        
                        Button("Post") {
                            postVideo()
                        }
                        .foregroundColor(DeepRedDesign.Colors.accent)
                        .disabled(isPosting)
                    }
                    .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    // Video Preview
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("Video Preview")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        )
                        .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                    
                    // Caption Input
                    VStack(alignment: .leading, spacing: DeepRedDesign.Spacing.xs) {
                        Text("Caption")
                            .font(DeepRedDesign.Typography.bodyBold)
                            .primaryText()
                        
                        TextField("Write a caption...", text: $caption, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(DeepRedDesign.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(DeepRedDesign.Colors.ash)
                            )
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
        isPosting = true
        HapticFeedback.impact(.medium)
        
        // Simulate posting
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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