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
        
        // Store the session for potential cleanup
        context.coordinator.captureSession = captureSession
        
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        var captureSession: AVCaptureSession?
        
        deinit {
            captureSession?.stopRunning()
        }
    }
    
    private func createFallbackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Camera Not Available"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(label)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Icon constraints
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Label constraints
            label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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