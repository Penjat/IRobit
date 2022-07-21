import SwiftUI
import Combine


struct CameraView: View {
    @StateObject var videoService = VideoService()
    @StateObject var faceDectectionService = FaceDetectionSerice()
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        ZStack {
            CameraPreviewView(session: videoService.videoCapture.captureSession)
            GeometryReader { geometry in
                if let box = faceDectectionService.faceObservations?.first?.boundingBox {
                    Rectangle().frame(width: 100, height: 100)
                }
            }
            
        }.onAppear {
            videoService.setUp()
            faceDectectionService.prepareVisionRequest()
            
            videoService.$sampleBuffer.compactMap{ $0 }.sink { buffer in
                faceDectectionService.input(sampleBuffer: buffer)
            }.store(in: &bag)
            
            faceDectectionService.$faceObservations.sink { observations in
                print(observations?.first?.boundingBox)
            }.store(in: &bag)
            
        }
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
