import Foundation
import Combine

class BehaviourInteractor: ObservableObject {
    @Published var cmdOutput: RobitCommand?
    func recive(command: RobitCommand) {
        print("interactor recievedc command")
        cmdOutput = command
    }
}
