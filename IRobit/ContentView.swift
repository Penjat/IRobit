import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var sensorService = PhoneSensorService()
    @State var sensorInput: SensorInput?
    
    @State var bag = Set<AnyCancellable>()
    var body: some View {
        Text("\(sensorInput?.roll ?? 0.0 )  \(sensorInput?.pitch ?? 0.0)  \(sensorInput?.yaw ?? 0.0)")
            .padding().onAppear() {
                sensorService.positionPublisher.sink { input in
                    sensorInput = input
                }.store(in: &bag)
            }       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
