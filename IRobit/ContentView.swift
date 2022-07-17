import SwiftUI

struct ContentView: View {
    @StateObject var sensorService = PhoneSensorService()
    var body: some View {
        Text("Hello, world!")
            .padding()
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
