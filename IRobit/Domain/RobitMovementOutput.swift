import Foundation

struct RobitMovementOutput: Equatable {
    let motor1Speed: Double
    let motor2Speed: Double
    
    static let STOPPED = RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0)
    static let LEFT = RobitMovementOutput(motor1Speed: -0.5, motor2Speed: 0.5)
    static let RIGHT = RobitMovementOutput(motor1Speed: 0.5, motor2Speed: -0.5)
}
