import SwiftUI
import AVFoundation

// MARK: - Camera Position Enum

enum CameraPosition {
    case front, back
}

// MARK: - Camera Preview View

struct CameraPreviewView: View {
    let cameraPosition: CameraPosition
    
    var body: some View {
        RealCameraPreview(cameraPosition: cameraPosition)
    }
}

// MARK: - Real Camera Preview with AVFoundation

struct RealCameraPreview: UIViewRepresentable {
    let cameraPosition: CameraPosition
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let captureDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: cameraPosition == .front ? .front : .back
        ) else {
            return createFallbackView()
        }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return createFallbackView()
        }
        
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update camera position if needed
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            let captureSession = previewLayer.session
            
            // Stop current session
            captureSession?.stopRunning()
            
            // Remove existing inputs
            captureSession?.inputs.forEach { input in
                captureSession?.removeInput(input)
            }
            
            // Add new input with correct camera position
            guard let captureDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: cameraPosition == .front ? .front : .back
            ) else { return }
            
            guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
            
            captureSession?.addInput(input)
            
            // Restart session
            DispatchQueue.global(qos: .background).async {
                captureSession?.startRunning()
            }
        }
    }
    
    private func createFallbackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.text = "Camera Not Available"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
}

// MARK: - Preview

#Preview("Camera Preview") {
    VStack(spacing: 20) {
        CameraPreviewView(cameraPosition: .front)
            .frame(height: 200)
            .cornerRadius(16)
        
        CameraPreviewView(cameraPosition: .back)
            .frame(height: 200)
            .cornerRadius(16)
    }
    .padding()
} 