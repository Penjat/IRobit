import SwiftUI
import Combine

struct RobitView: View {
    @EnvironmentObject var behaviourInteractor: BehaviourInteractor
    @StateObject var brain = RobitBrain()
    @StateObject var sensorService = PhoneSensorService()
    @StateObject var bodyInteractor = BodyInteractor()
//    @StateObject var speechService = SpeechService()
    @State var sensorInput: SensorInput?
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        ZStack {
            
            Circle()
                .fill(brain.goal == .idle ? Color.green : .orange)
                .frame(width: 300, height: 300)
                .overlay(
                    ZStack {
                        Path { path in
                            path.move(to: CGPoint(x: 150, y: 150))
                            path.addLine(to: linePosition)
                        }.stroke(.blue, lineWidth: 4)
                        
                        switch brain.goal {
                        case .face(angle: let angle):
                            Path { path in
                                path.move(to: CGPoint(x: 150, y: 150))
                                path.addLine(to: CGPoint(x: sin(angle)*150 + 150, y: cos(angle)*150 + 150 ))
                            }.stroke(.black, lineWidth: 6)
                        default:
                            EmptyView()
                        }
                    }
                )
            if brain.goal != .idle {
                Text("\(brain.movementOutput == .LEFT ? "LEFT" : "RIGHT")").font(.title).opacity(0.6)
            }
            
            VStack {
                Text("\(goalText)")
                    .padding()
                
                Text(String(format: "%.2f", sensorInput?.yaw ?? 0.00))
                    .padding()
                HStack {
                    Button("North") {
                        brain.commandInput.send(.faceNorth)
                    }
                    Button("East") {
                        brain.commandInput.send(.faceEast)
                    }
                    Button("South") {
                        brain.commandInput.send(.faceSouth)
                    }
                    Button("West") {
                        brain.commandInput.send(.sequence(goals: [.face(angle: 0.0),.face(angle: Double.pi), .face(angle: 1.1), .face(angle: -2.4)]))
                    }
                }
                
                Text(bodyInteractor.connectedBody != nil ? "connected" : "not-connected")
            }
            
        }
        .onAppear {
//            speechService.reset()
//            speechService.transcribe()
            //            speechService.$transcript.sink { transcript in
            //                if transcript.contains("north") {
            //                    brain.commandInput.send(.faceNorth)
            //                    speechService.transcript = ""
            //                    print("said north")
            //                }
            //            }.store(in: &bag)
            
            sensorService.positionPublisher.sink { input in
                sensorInput = input
                brain.sensorInput.send(input)
            }.store(in: &bag)
            
            brain.$movementOutput.sink { output in
                bodyInteractor.toBody.send(output)
            }.store(in: &bag)
            
            bodyInteractor.start()
            
            behaviourInteractor.$cmdOutput.compactMap({$0}).sink { cmd in
                brain.commandInput.send(cmd)
            }.store(in: &bag)
        }
    }
    
    var linePosition: CGPoint {
        CGPoint(x: sin(sensorInput?.yaw ?? 0.0)*150 + 150, y: cos(sensorInput?.yaw ?? 0.0)*150 + 150)
    }
    
    var goalText: String {
        switch brain.goal {
            
        case .idle:
            return "idle"
        case .face(angle: let angle):
            return "face \(angle)"
        }
    }
}
struct RobitView_Previews: PreviewProvider {
    static var previews: some View {
        RobitView()
    }
}
