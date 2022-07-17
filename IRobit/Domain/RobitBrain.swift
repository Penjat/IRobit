import Foundation
import Combine

class RobitBrain: ObservableObject {
    let commandInput = PassthroughSubject<RobitCommand, Never>()
    @Published var movementOutput = RobitMovementOutput(motor1Speed: 0.0, motor2Speed: 0.0)
}
