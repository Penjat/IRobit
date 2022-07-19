import SwiftUI

@main
struct IRobitApp: App {
    let behaviourInteractor = BehaviourInteractor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(behaviourInteractor)
                .onContinueUserActivity(NSStringFromClass(FaceDirectionIntent.self), perform: { userActivity in
                    guard let intent = userActivity.interaction?.intent as? FaceDirectionIntent else {
                        return
                    }
                    let command: RobitCommand = { () -> RobitCommand in
                        switch intent.direction {

                        case .unknown:
                            return .faceNorth
                        case .north:
                            return .faceNorth
                        case .south:
                            return .faceSouth
                        case .east:
                            return .faceEast
                        case .west:
                            return .faceWest
                        }
                    }()
                    
                    behaviourInteractor.recive(command: command)
            })
        }
    }
}
