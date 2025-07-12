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
                    .stroke(.white.opacity(0.3), lineWidth: 4)
                    .frame(width: 70, height: 70)
                
                Circle()
                    .trim(from: 0, to: recordingProgress)
                    .stroke(
                        DeepRedDesign.Colors.accent,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: recordingProgress)
            }
            

            
            // Record Button
            Button(action: onButtonPress) {
                ZStack {
                    // Outer Ring (thin stroke)
                    Circle()
                        .stroke(DeepRedDesign.Colors.accent, lineWidth: 2)
                        .frame(width: 60, height: 60)
                        .shadow(
                            color: DeepRedDesign.Colors.accent.opacity(0.4),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                    
                    // Inner Circle (thick, solid)
                    Circle()
                        .fill(DeepRedDesign.Colors.accent)
                        .frame(
                            width: isRecording ? 24 : 44,
                            height: isRecording ? 24 : 44
                        )
                        .cornerRadius(isRecording ? 4 : 22)
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