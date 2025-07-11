import SwiftUI

// MARK: - Camera Record Button Component

struct CameraRecordButton: View {
    let isRecording: Bool
    let recordingProgress: Double
    let onButtonPress: () -> Void
    
    var body: some View {
        ZStack {
            // Progress Ring (when recording)
            if isRecording {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 6)
                    .frame(width: 90, height: 90)
                
                Circle()
                    .trim(from: 0, to: recordingProgress)
                    .stroke(
                        DeepRedDesign.Colors.accent,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: recordingProgress)
            }
            

            
            // Record Button
            Button(action: onButtonPress) {
                ZStack {
                    // Outer Ring (thin stroke)
                    Circle()
                        .stroke(DeepRedDesign.Colors.accent, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .shadow(
                            color: DeepRedDesign.Colors.accent.opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                    
                    // Inner Circle (thick, solid)
                    Circle()
                        .fill(DeepRedDesign.Colors.accent)
                        .frame(
                            width: isRecording ? 32 : 56,
                            height: isRecording ? 32 : 56
                        )
                        .cornerRadius(isRecording ? 6 : 28)
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isRecording)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Camera Record Button") {
    VStack(spacing: 40) {
        // Normal State
        CameraRecordButton(
            isRecording: false,
            recordingProgress: 0,
            onButtonPress: {}
        )
        
        // Recording State
        CameraRecordButton(
            isRecording: true,
            recordingProgress: 0.3,
            onButtonPress: {}
        )
    }
    .padding()
    .background(Color.black)
} 