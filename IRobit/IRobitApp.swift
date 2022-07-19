import SwiftUI

@main
struct IRobitApp: App {
    let behaviourInteractor = BehaviourInteractor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(behaviourInteractor)
                .onContinueUserActivity(NSStringFromClass(FaceDirectionIntent.self), perform: { userActivity in
                //do something
                    behaviourInteractor.reciveIntent()
            })
        }
    }
}
