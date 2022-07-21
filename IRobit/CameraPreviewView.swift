import UIKit
import SwiftUI
import AVFoundation

class PreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard
            let layer = layer as? AVCaptureVideoPreviewLayer
        else { fatalError("Could not get layer") }
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        return layer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    let preview = PreviewView()
    func makeUIView(context: Context) -> PreviewView {
        
        preview.videoPreviewLayer.session = session
        
        return preview
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}
