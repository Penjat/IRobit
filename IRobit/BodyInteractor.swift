import Foundation
import Combine
import CoreBluetooth

class BodyInteractor: ObservableObject {
    let toBody = PassthroughSubject<RobitMovementOutput, Never>()
    
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    var dataSubject = PassthroughSubject<Data, Never>()
    
    @Published var state: CBManagerState = .unknown
    @Published var peripherals: [CBPeripheral] = []
    
    @Published var motorSpeed = (motor1Speed: 0, motor2Speed: 0)
    
    lazy var manager: BluetoothCentralService = BluetoothCentralService()
    private lazy var bag: Set<AnyCancellable> = .init()
    @Published var connectedBody: CBPeripheral?
    
    func start() {
        toBody
            .throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] output in
                self?.sendPacket(speed1: Int(output.motor1Speed*100), speed2: Int(output.motor2Speed*100))
            }.store(in: &bag)
        
        manager.eventSubject.sink(receiveValue: { event in
            switch event {
            case .DidUpdateState(state: let state):
                self.processUpdateState(state: state)
            case .DidDiscover(central: _, peripheral: let peripheral):
                if peripheral.name == "SiriBody" {
                    print("SiriBody Found!!!!!!!! \(peripheral)")
                    self.peripherals.append(peripheral)
                    self.manager.connect(peripheral)
                }
            case .DidConnect(central: _, peripheral: let peripheral):
                self.connectedBody = peripheral
                self.connectedBody?.discoverServices(nil)
            case .DidDiscoverService(peripheral: let peripheral, error: let error):
                if ((error) != nil) {
//                    print("Error discovering services: \(error!.localizedDescription)")
                    return
                }
                guard let services = peripheral.services else {
                    return
                }
                //We need to discover the all characteristic
                for service in services {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
//                print("Discovered Services: \(services)")
            case .DidDiscoverCharacteristic(peripheral: _, service: let service, error: let error):
                guard let characteristics = service.characteristics else {
                    return
                }
                for characteristic in characteristics {
//                    print("\(characteristic)")
                    self.txCharacteristic = characteristic
//                    print("TX Characteristic: \(self.txCharacteristic.uuid)")
                }
                
            case .DidDisconnect(central: let central, peripheral: let peripheral, error: let error):
                self.connectedBody = nil
                self.manager.startScanning()
            }
        }).store(in: &bag)
        
        manager.start()
        
    }
    
    private func processUpdateState(state: CBManagerState) {
        switch state {
        case .unknown:
            print("unkown")
        case .resetting:
            print("restting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthourised")
        case .poweredOff:
            print("power off")
        case .poweredOn:
            print("power on")
            self.manager.startScanning()
        }
    }
    
    private func sendPacket(speed1: Int, speed2: Int) {
        let s1 = (speed1*7)/100 + 7
        let s2 = ((speed2*7)/100 + 7) << 4
        let data = Data([UInt8(min(s1 + s2, 256))])
        sendData(data)
    }
    
    private func sendData(_ data: Data) {
        if let bluefruitPeripheral = connectedBody {
            if let txCharacteristic = txCharacteristic {
                bluefruitPeripheral.writeValue(data, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
}
