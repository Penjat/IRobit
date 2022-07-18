import SwiftUI
import Combine

struct RobitView: View {
    @StateObject var brain = RobitBrain()
    @StateObject var sensorService = PhoneSensorService()
    @State var sensorInput: SensorInput?
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        ZStack {
            
            Circle()
                .fill(.orange)
                .frame(width: 300, height: 300)
                .overlay(
                    Path { path in
                        path.move(to: CGPoint(x: 150, y: 150))
                        path.addLine(to: linePosition)
                    }.stroke(.blue, lineWidth: 4))
            
            VStack {
                Text("\(goalText)")
                //            Text("\(sensorInput?.roll ?? 0.0 )  \(sensorInput?.pitch ?? 0.0)  \(sensorInput?.yaw ?? 0.0)")
                //                .padding()
                
                Text("\(sensorInput?.yaw ?? 0.0)")
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
                        brain.commandInput.send(.faceWest)
                    }
                }
            }
        }
        .onAppear {
            sensorService.positionPublisher.sink { input in
                sensorInput = input
                brain.sensorInput.send(input)
                print(linePosition)
            }.store(in: &bag)
            
        }
    }
    
    var linePosition: CGPoint {
        CGPoint(x: cos(sensorInput?.yaw ?? 0.0)*150 + 150, y: sin(sensorInput?.yaw ?? 0.0)*150 + 150)
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
