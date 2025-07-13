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
    
    // Recording components
    @StateObject private var cameraManager = CameraManager()
    @State private var recordingTimer: Timer?
    
    // Gesture handling
    @State private var tapCount = 0
    @State private var tapTimer: Timer?
    
    private let maxRecordingTime: TimeInterval = 30.0
    
    var body: some View {
        ZStack {
            // Camera Preview Background
            Color.black
                .ignoresSafeArea()
            
            // Camera Preview
            CameraPreviewUIView(cameraManager: cameraManager)
                .ignoresSafeArea()
                .onTapGesture {
                    handleTap()
                }
            
            // UI Overlay
            VStack {
                // Top Controls
                HStack {
                    // Close Button
                    Button(action: {
                        stopRecording()
                        cameraManager.stopCameraSession()
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
        .onDisappear {
            cameraManager.cleanup()
            tapTimer?.invalidate()
            tapTimer = nil
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
        .onChange(of: cameraManager.recordedVideoURL) { _, newURL in
            if let url = newURL {
                print("🎥 Received recorded video URL: \(url)")
                print("📱 Stopping camera for preview...")
                
                // Stop camera immediately when recording completes
                cameraManager.stopCameraSession()
                
                recordedVideoURL = url
                showPostView = true
                print("✅ showPostView set to true")
            }
        }
        .onChange(of: cameraManager.isSessionRunning) { _, isRunning in
            print("📹 Camera session running state changed: \(isRunning)")
        }
    }
    
    // MARK: - Private Methods
    
    private func setupCamera() {
        print("🎬 Setting up camera...")
        currentCamera = useBackCamera ? .back : .front
        cameraManager.setupCamera(position: currentCamera)
        HapticFeedback.impact(.light)
    }
    
    private func handleTap() {
        tapCount += 1
        
        // Cancel any existing timer
        tapTimer?.invalidate()
        
        // Set a timer to handle the tap after a delay
        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            if tapCount == 1 {
                // Single tap - focus (placeholder)
                HapticFeedback.impact(.light)
            } else if tapCount >= 2 {
                // Double tap - switch camera
                switchCamera()
            }
            
            // Reset tap count
            tapCount = 0
        }
    }
    
    private func switchCamera() {
        print("🔄 Switching camera...")
        currentCamera = currentCamera == .front ? .back : .front
        cameraManager.switchCamera(to: currentCamera)
        HapticFeedback.impact(.medium)
    }
    
    private func startRecording() {
        print("🎬 Starting recording...")
        
        isRecording = true
        recordingDuration = 0
        recordingProgress = 0
        
        // Create output URL
        let outputURL = createVideoURL()
        print("📁 Recording to: \(outputURL.absoluteString)")
        
        // Start recording
        cameraManager.startRecording(to: outputURL)
        
        HapticFeedback.notification(.success)
        
        // Start recording timer
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
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
        print("🛑 Finishing recording...")
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        cameraManager.stopRecording()
        HapticFeedback.notification(.success)
    }
    
    private func createVideoURL() -> URL {
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

// MARK: - Camera Manager

class CameraManager: ObservableObject {
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var currentPosition: CameraPosition = .front
    private var recordingDelegate: VideoRecordingDelegate?
    
    @Published var recordedVideoURL: URL?
    @Published var isSessionRunning = false
    @Published var cameraPosition: CameraPosition = .front
    
    func setupCamera(position: CameraPosition) {
        print("📹 Setting up camera session for position: \(position)")
        
        currentPosition = position
        
        // Create session if it doesn't exist
        if captureSession == nil {
            captureSession = AVCaptureSession()
        }
        
        guard let session = captureSession else { return }
        
        // Configure session on background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            session.beginConfiguration()
            session.sessionPreset = .high
            
            // Remove existing inputs
            session.inputs.forEach { input in
                session.removeInput(input)
            }
            
            // Remove existing outputs
            session.outputs.forEach { output in
                session.removeOutput(output)
            }
            
            guard let captureDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: position == .front ? .front : .back
            ) else { 
                print("❌ Could not get capture device")
                session.commitConfiguration()
                return 
            }
            
            guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else { 
                print("❌ Could not create video input")
                session.commitConfiguration()
                return 
            }
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                print("✅ Added video input")
            }
            
            // Add audio input (with error handling)
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                do {
                    let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                    if session.canAddInput(audioInput) {
                        session.addInput(audioInput)
                        print("✅ Added audio input")
                    } else {
                        print("⚠️ Cannot add audio input to session")
                    }
                } catch {
                    print("⚠️ Failed to create audio input: \(error.localizedDescription)")
                }
            } else {
                print("⚠️ Could not get audio device")
            }
            
            // Setup movie file output
            let movieOutput = AVCaptureMovieFileOutput()
            if session.canAddOutput(movieOutput) {
                session.addOutput(movieOutput)
                print("✅ Added movie output")
                
                // Configure video mirroring for front camera
                if let videoConnection = movieOutput.connection(with: .video) {
                    if position == .front {
                        videoConnection.automaticallyAdjustsVideoMirroring = false
                        videoConnection.isVideoMirrored = true
                        print("🪞 Front camera video output mirrored")
                    } else {
                        videoConnection.automaticallyAdjustsVideoMirroring = false
                        videoConnection.isVideoMirrored = false
                        print("📹 Back camera video output normal")
                    }
                }
            }
            
            session.commitConfiguration()
            
            DispatchQueue.main.async {
                self?.videoOutput = movieOutput
                self?.currentPosition = position
                self?.cameraPosition = position
            }
            
            // Start session if not already running
            if !session.isRunning {
                session.startRunning()
            }
            
            DispatchQueue.main.async {
                self?.isSessionRunning = session.isRunning
                print("✅ Camera session started: \(session.isRunning)")
            }
        }
    }
    
    func switchCamera(to position: CameraPosition) {
        print("🔄 Switching camera to: \(position)")
        setupCamera(position: position)
    }
    
    func startRecording(to url: URL) {
        print("🎬 Starting recording to: \(url)")
        
        recordingDelegate = VideoRecordingDelegate { [weak self] recordedURL, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Recording failed: \(error)")
                    return
                }
                
                guard let recordedURL = recordedURL else {
                    print("❌ No URL provided for recorded video")
                    return
                }
                
                print("✅ Recording completed successfully! URL: \(recordedURL)")
                self?.recordedVideoURL = recordedURL
            }
        }
        
        videoOutput?.startRecording(to: url, recordingDelegate: recordingDelegate!)
        print("✅ Recording started")
    }
    
    func stopRecording() {
        print("🛑 Stopping recording...")
        videoOutput?.stopRecording()
    }
    
    func stopCameraSession() {
        print("📹 Stopping camera session...")
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.stopRunning()
            DispatchQueue.main.async {
                self?.isSessionRunning = false
                print("✅ Camera session stopped")
            }
        }
    }
    
    func getSession() -> AVCaptureSession? {
        return captureSession
    }
    
    func getCurrentPosition() -> CameraPosition {
        return currentPosition
    }
    
    func cleanup() {
        print("🧹 Cleaning up camera session...")
        captureSession?.stopRunning()
        captureSession = nil
        videoOutput = nil
        recordingDelegate = nil
    }
}

// MARK: - Camera Preview UIView

struct CameraPreviewUIView: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        context.coordinator.parentView = view
        
        // Set up preview layer immediately if session is available
        if let session = cameraManager.getSession(), cameraManager.isSessionRunning {
            context.coordinator.setupPreviewLayerOnce(with: session, in: view)
            context.coordinator.updatePreviewMirroring(for: cameraManager.getCurrentPosition())
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Get current session
        guard let session = cameraManager.getSession() else { return }
        
        // Set up or update preview layer
        if context.coordinator.previewLayer == nil {
            context.coordinator.setupPreviewLayerOnce(with: session, in: uiView)
        } else {
            // Update existing preview layer with new session
            context.coordinator.updatePreviewLayer(with: session)
        }
        
        // Update frame if preview layer exists
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = uiView.bounds
        }
        
        // Update mirroring when camera position changes
        context.coordinator.updatePreviewMirroring(for: cameraManager.getCurrentPosition())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        var previewLayer: AVCaptureVideoPreviewLayer?
        var parentView: UIView?
        
        func setupPreviewLayerOnce(with session: AVCaptureSession, in view: UIView) {
            // Only create if we don't already have one
            guard previewLayer == nil else { return }
            
            print("📹 Setting up preview layer...")
            
            let newPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            newPreviewLayer.frame = view.bounds
            newPreviewLayer.videoGravity = .resizeAspectFill
            
            view.layer.addSublayer(newPreviewLayer)
            self.previewLayer = newPreviewLayer
            
            print("✅ Preview layer setup complete")
        }
        
        func updatePreviewLayer(with session: AVCaptureSession) {
            guard let previewLayer = previewLayer else { return }
            
            // Update the preview layer's session
            if previewLayer.session != session {
                print("🔄 Updating preview layer with new session")
                previewLayer.session = session
            }
        }
        
        func updatePreviewMirroring(for position: CameraPosition) {
            guard let previewLayer = previewLayer else { return }
            
            // Mirror the preview for front camera (like a mirror)
            if position == .front {
                previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                previewLayer.connection?.isVideoMirrored = true
                print("🪞 Front camera preview mirrored")
            } else {
                previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                previewLayer.connection?.isVideoMirrored = false
                print("📹 Back camera preview normal")
            }
        }
        
        func removePreviewLayer() {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        }
    }
}

// MARK: - Video Recording Delegate

class VideoRecordingDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    private let completion: (URL?, Error?) -> Void
    
    init(completion: @escaping (URL?, Error?) -> Void) {
        self.completion = completion
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("📹 Recording delegate called - URL: \(outputFileURL), Error: \(error?.localizedDescription ?? "none")")
        completion(outputFileURL, error)
    }
}

// MARK: - Preview

#Preview("Camera Recording") {
    CameraRecordingView(useBackCamera: false) {
        print("Recording dismissed")
    }
} 