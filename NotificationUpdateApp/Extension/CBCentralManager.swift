//
//  CBCentralManager.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import CoreBluetooth

enum BluetoothState {
    case permissionDenied
    case bluetoothNotAllowed
    case readyForWork
    
    var canStartSearch: Bool {
        switch self {
        case .permissionDenied:
            return false
        case .bluetoothNotAllowed:
            return false
        case .readyForWork:
            return true
        }
    }
}

extension CBCentralManager {
    var bluetoothState: BluetoothState {
        if #available(iOS 13, *) {
            if authorization != .allowedAlways {
                return .permissionDenied
            }
        }
        if state != .poweredOn {
            return .bluetoothNotAllowed
        }
        return .readyForWork
    }
}
