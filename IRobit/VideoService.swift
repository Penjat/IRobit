import Combine
import AVFoundation
import SwiftUI

class VideoService: ObservableObject {
    let videoCapture = VideoCapture()
    @Published var currentFrame: CGImage?
    @Published var sampleBuffer: CMSampleBuffer?
    
    func setUp() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }
            self.videoCapture.delegate = self
            self.videoCapture.startCapturing()
        }
    }
}

extension VideoService: VideoCaptureDelegate {
    func videoSampleBuffer(_ videoCapture: VideoCapture, sampleBuffer: CMSampleBuffer) {
        self.sampleBuffer = sampleBuffer
    }
    
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }
        currentFrame = image
    }
}
