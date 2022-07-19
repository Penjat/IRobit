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
            self?.handleCommandInput(command: command)
        }.store(in: &bag)
        
        sensorInput.sink { [weak self] sensorInput in
            self?.handleSensorInput(sensorInput: sensorInput)
        }.store(in: &bag)
    }
    
    func handleCommandInput(command: RobitCommand) {
        switch command {
        case .stop:
            movementOutput = RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0)
            goal = .idle
        case .faceNorth:
            goal = .face(angle: 0.0)
        case .faceEast:
            goal = .face(angle: Double.pi/2)
        case .faceSouth:
            goal = .face(angle: Double.pi)
        case .faceWest:
            goal = .face(angle: Double.pi/(-2))
        }
    }
    
    func handleSensorInput(sensorInput: SensorInput) {
        switch goal {
        case .idle:
            if movementOutput != .STOPPED {
                movementOutput = .STOPPED
            }
        case .face(angle: let angle):
            if abs( sensorInput.yaw - angle) < 0.15 {
                movementOutput = RobitMovementOutput.STOPPED
                goal = .idle
                return
            }
            let diff = angle - sensorInput.yaw
            if  diff > Double.pi  {
                movementOutput = .RIGHT
                
            } else if diff < -Double.pi {
                movementOutput = .LEFT
            } else {
                movementOutput = diff > 0 ? .LEFT : .RIGHT
            }
        }
    }
}
