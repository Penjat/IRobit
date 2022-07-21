import SwiftUI
import Combine


struct CameraView: View {
    @StateObject var videoService = VideoService()
    @StateObject var faceDectectionService = FaceDetectionSerice()
    @State var bag = Set<AnyCancellable>()
    @State var box: CGRect?
    var body: some View {
        ZStack {
            CameraPreviewView(session: videoService.videoCapture.captureSession)
            GeometryReader { geometry in
//                if let box = faceDectectionService.faceObservations?.first?.boundingBox {
//                    Path { path in
//                        path.move(to: CGPoint(x: box.minX*geometry.size.width, y: box.minY*geometry.size.height))
//                        path.addLine(to: CGPoint(x: box.minX*geometry.size.width, y: box.maxY*geometry.size.height))
//                        path.addLine(to: CGPoint(x: box.maxX*geometry.size.width, y: box.maxY*geometry.size.height))
//                        path.addLine(to: CGPoint(x: box.maxX*geometry.size.width, y: box.minY*geometry.size.height))
//                        path.addLine(to: CGPoint(x: box.minX*geometry.size.width, y: box.minY*geometry.size.height))
//                    }.fill(.orange)
//                }
            }
            Text(turnDirectionText).font(.title)
            
        }.onAppear {
            videoService.setUp()
            faceDectectionService.prepareVisionRequest()
            
            videoService.$sampleBuffer.compactMap{ $0 }.sink { buffer in
                faceDectectionService.input(sampleBuffer: buffer)
            }.store(in: &bag)
            
            faceDectectionService.$faceObservations.sink { observations in
                self.box = observations?.first?.boundingBox ?? nil
            }.store(in: &bag)
        }
    }
    
    var turnDirectionText: String {
        guard let box = box else {
            return "no face"
        }
        let center = box.minX + box.width/2.0
        if center > 0.65 {
            return "turn right"
        }
        
        if center < 0.35 {
            return "turn left"
        }
        
        return "center"
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
