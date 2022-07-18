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
                self?.goal = .face(angle: Double.pi/2)
            case .faceSouth:
                self?.goal = .face(angle: Double.pi)
            case .faceWest:
                self?.goal = .face(angle: Double.pi/(-2))
            }
        }.store(in: &bag)
        
        sensorInput.sink { [weak self] sensorInput in
            switch self?.goal {
            case .idle:
                break
            case .face(angle: let angle):
                if abs( sensorInput.yaw - angle) < 0.15 {
                    self?.movementOutput = RobitMovementOutput.STOPPED
                    self?.goal = .idle
                    return
                }
                let diff = angle - sensorInput.yaw
                if  diff > Double.pi  {
                    self?.movementOutput = .RIGHT
                    
                } else if diff < -Double.pi {
                    self?.movementOutput = .LEFT
                } else {
                    self?.movementOutput = diff > 0 ? .LEFT : .RIGHT
                }
                
                
            case .none:
                break
            }
        }.store(in: &bag)
    }
    
    
}
