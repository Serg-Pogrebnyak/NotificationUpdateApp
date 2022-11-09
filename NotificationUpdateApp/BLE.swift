//
//  BLE.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import Foundation
import CoreBluetooth

protocol BLEDelegate: AnyObject {
    func notifyThatFoundNewDeviceInScanningTime(device: CBPeripheral)
    func didConnectToDevice()
}

final class BLE: NSObject {
    
    weak var delegate: BLEDelegate?
    var bluetoothState: BluetoothState { manager.bluetoothState }
    
    private let manager = CBCentralManager()

    private var blePeripheral: CBPeripheral?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startSearchDevices() -> Bool {
        guard !manager.isScanning else { return false }
        
        if let blePeripheral = blePeripheral {
            manager.cancelPeripheralConnection(blePeripheral)
        }
        manager.scanForPeripherals(withServices: nil,
                                   options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.stopSearch()
        }
        return true
    }
    
    func connectTo(device: CBPeripheral) {
        stopSearch()
        blePeripheral = device
        manager.connect(device, options: nil)
    }
    
    private func stopSearch() {
        manager.stopScan()
    }
}

extension BLE: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //no-op
    }
}

extension BLE: CBPeripheralDelegate {
    //delegate when find new device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral:CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.notifyThatFoundNewDeviceInScanningTime(device: peripheral)
    }
    
    //didConnect
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didConnectToDevice()
    }
}
