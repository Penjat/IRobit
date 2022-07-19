import Foundation
import Combine

class BehaviourInteractor: ObservableObject {
    @Published var cmdOutput: RobitCommand?
    func reciveIntent() {
        print("interactor recievedc intent")
        cmdOutput = .faceNorth
    }
}
