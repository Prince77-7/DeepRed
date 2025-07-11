import SwiftUI
import AVFoundation

// MARK: - Camera Recording View

struct CameraRecordingView: View {
    let useBackCamera: Bool
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentCamera: CameraPosition = .front
    @State private var isRecording = false
    @State private var recordingProgress: Double = 0.0
    @State private var recordingDuration: TimeInterval = 0
    @State private var showPostView = false
    @State private var recordedVideoURL: URL?
    
    private let maxRecordingTime: TimeInterval = 30.0
    
    var body: some View {
        ZStack {
            // Camera Preview Background
            Color.black
                .ignoresSafeArea()
            
            // Camera Preview
            CameraPreviewView(cameraPosition: currentCamera)
                .ignoresSafeArea()
                .onTapGesture(count: 2) {
                    // Double tap to switch camera
                    switchCamera()
                }
                .onTapGesture {
                    // Single tap to focus (placeholder)
                    HapticFeedback.impact(.light)
                }
            
            // UI Overlay
            VStack {
                // Top Controls
                HStack {
                    // Close Button
                    Button(action: {
                        stopRecording()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.black.opacity(0.4))
                                    .blur(radius: 0.5)
                            )
                    }
                    
                    Spacer()
                    
                    // Camera Switch Button
                    Button(action: {
                        switchCamera()
                    }) {
                        Image(systemName: "camera.rotate.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.black.opacity(0.4))
                                    .blur(radius: 0.5)
                            )
                    }
                    .disabled(isRecording)
                }
                .padding(.horizontal, DeepRedDesign.Spacing.screenMargin)
                .padding(.top, DeepRedDesign.Spacing.md)
                
                Spacer()
                
                // Recording Controls
                VStack(spacing: DeepRedDesign.Spacing.lg) {
                    // Recording Duration (when recording)
                    if isRecording {
                        HStack(spacing: DeepRedDesign.Spacing.xs) {
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                                .opacity(0.8)
                            
                            Text(formatTime(recordingDuration))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.black.opacity(0.5))
                                .blur(radius: 0.5)
                        )
                    }
                    
                    // Record Button
                    CameraRecordButton(
                        isRecording: isRecording,
                        recordingProgress: recordingProgress,
                        onButtonPress: {
                            if isRecording {
                                stopRecording()
                            } else {
                                startRecording()
                            }
                        }
                    )
                }
                .padding(.bottom, DeepRedDesign.Spacing.xl)
            }
            

        }
        .onAppear {
            setupCamera()
        }
        .fullScreenCover(isPresented: $showPostView, onDismiss: {
            dismiss()
        }) {
            if let videoURL = recordedVideoURL {
                VideoPostView(videoURL: videoURL) {
                    // This will automatically dismiss the fullScreenCover
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupCamera() {
        currentCamera = useBackCamera ? .back : .front
        HapticFeedback.impact(.light)
    }
    
    private func switchCamera() {
        currentCamera = currentCamera == .front ? .back : .front
        HapticFeedback.impact(.medium)
    }
    
    private func startRecording() {
        isRecording = true
        recordingDuration = 0
        recordingProgress = 0
        
        HapticFeedback.notification(.success)
        
        // Start recording timer
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if isRecording {
                recordingDuration += 0.1
                recordingProgress = recordingDuration / maxRecordingTime
                
                if recordingDuration >= maxRecordingTime {
                    timer.invalidate()
                    finishRecording()
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func stopRecording() {
        if isRecording {
            finishRecording()
        }
    }
    
    private func finishRecording() {
        isRecording = false
        HapticFeedback.notification(.success)
        
        // Simulate saving video
        recordedVideoURL = createDummyVideoURL()
        showPostView = true
    }
    
    private func createDummyVideoURL() -> URL {
        // Create a dummy URL for the recorded video
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("recorded_video_\(Date().timeIntervalSince1970).mp4")
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "0:00"
    }
}

// MARK: - Preview

#Preview("Camera Recording") {
    CameraRecordingView(useBackCamera: false) {
        print("Recording dismissed")
    }
} 