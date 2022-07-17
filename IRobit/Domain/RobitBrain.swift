import Foundation
import Combine

class RobitBrain: ObservableObject {
    let commandInput = PassthroughSubject<RobitCommand, Never>()
    let sensorInput = PassthroughSubject<SensorInput, Never>()
    
    @Published var goal = RobitGoal.idle
    @Published var movementOutput = RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0)
    
    var bag = Set<AnyCancellable>()
    
    init() {
        commandInput.sink { [weak self] command in
            switch command {
            case .stop:
                self?.movementOutput = RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0)
                self?.goal = .idle
                break
            case .faceNorth:
                self?.goal = .face(angle: 0.0)
            case .faceEast:
                break
            case .faceSouth:
                break
            case .faceWest:
                break
            }
        }.store(in: &bag)
        
        sensorInput.sink { [weak self] sensorInput in
            switch self?.goal {
            case .idle:
                break
            case .face(angle: let angle):
                print("\(angle) \(sensorInput)")
            case .none:
                break
            }
        }.store(in: &bag)
    }
}
