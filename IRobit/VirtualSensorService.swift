import Foundation
import Combine

/// VirtualSensorService:
/// This class is to be used in testing to asses the RobitBrain classes output response given certain inputs
class VirtualSensorService: SensorService {
    var positionPublisher = PassthroughSubject<SensorInput, Never>()
    
}
