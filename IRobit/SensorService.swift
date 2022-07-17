import Foundation
import Combine
import CoreMotion

protocol SensorService: ObservableObject {
    var positionPublisher: PassthroughSubject<CMDeviceMotion, Never> { get }
}

class PhoneSensorService: ObservableObject, SensorService {
    let motionManager = CMMotionManager()
    var bag = Set<AnyCancellable>()
    var positionPublisher = PassthroughSubject<CMDeviceMotion, Never>()
    public init() {
        print("created sensor service.")
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
            guard let data = data else {
                return
            }
            self.positionPublisher.send(data)
        }
    }
}
