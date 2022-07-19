import Foundation
import Combine

class RobitBrain: ObservableObject {
    let commandInput = PassthroughSubject<RobitCommand, Never>()
    let sensorInput = PassthroughSubject<SensorInput, Never>()
    var goalSequence: GoalSequence?
    
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
        case .sequence(goals: let goals):
            goalSequence = GoalSequence(goals: goals, index: 0)
            goal = goals[0]
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
                completedGoal()
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
        case .wait(relativeTime: let relativeTime, specificTime: let specificTime):
            if movementOutput != .STOPPED {
                movementOutput = .STOPPED
            }
            guard let specificTime = specificTime else {
                goal = .wait(relativeTime: relativeTime, specificTime: Date.now.addingTimeInterval(relativeTime).timeIntervalSince1970)
                return
            }
            if specificTime < Date.now.timeIntervalSince1970 {
                completedGoal()
            }
        }
    }
    
    func completedGoal() {
        guard let goalSequence = goalSequence, goalSequence.index+1 < goalSequence.goals.count else {
            goalSequence = nil
            movementOutput = RobitMovementOutput.STOPPED
            goal = .idle
            return
        }
        self.goalSequence?.index += 1
        self.goal = goalSequence.nextGoal()
    }
}
