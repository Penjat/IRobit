import Foundation
import Combine
import CoreMotion

protocol SensorService: ObservableObject {
    var positionPublisher: PassthroughSubject<SensorInput, Never> { get }
}

class PhoneSensorService: ObservableObject, SensorService {
    let motionManager = CMMotionManager()
    var bag = Set<AnyCancellable>()
    var positionPublisher = PassthroughSubject<SensorInput, Never>()
    public init() {
        print("created sensor service.")
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
            guard let data = data else {
                return
            }
            self.positionPublisher.send(SensorInput(pitch: data.attitude.pitch, yaw: data.attitude.yaw, roll: data.attitude.roll))
        }
    }
    
}
