import UIKit
import SwiftUI
import AVFoundation
import Combine
import Vision

class PreviewView: UIView {
    var cancellable: AnyCancellable?
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
    let observable: AnyPublisher<[VNFaceObservation]?, Never>
    let preview = PreviewView()
    func makeUIView(context: Context) -> PreviewView {
        print("making view")
        preview.videoPreviewLayer.session = session
        preview.cancellable = observable.sink(receiveValue: { observations in
            print("UIView recieved observation")
        })
        return preview
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}
