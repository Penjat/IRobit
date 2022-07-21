import SwiftUI
import Combine


struct CameraView: View {
    @StateObject var videoService = VideoService()
    @StateObject var brain = RobitBrain()
    @StateObject var sensorService = PhoneSensorService()
    @StateObject var bodyInteractor = BodyInteractor()
    @StateObject var faceDectectionService = FaceDetectionSerice()
    
    @State var sensorInput: SensorInput?
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
                
                guard let box = observations?.first?.boundingBox else {
                    brain.goal = .idle
                    return
                }
                let center = box.minX + box.width/2.0
                if center > 0.65 {
                    brain.goal = .driveAt(motor1Speed: -0.4, motor2Speed: 0.4)
                    return
                }
                
                if center < 0.35 {
                    brain.goal = .driveAt(motor1Speed: 0.4, motor2Speed: -0.4)
                    return
                }
                brain.goal = .idle
            }.store(in: &bag)
            
            
            
            sensorService.positionPublisher.sink { input in
                sensorInput = input
                brain.sensorInput.send(input)
            }.store(in: &bag)
            
            brain.$movementOutput.sink { output in
                bodyInteractor.toBody.send(output)
            }.store(in: &bag)
            
            bodyInteractor.start()
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
