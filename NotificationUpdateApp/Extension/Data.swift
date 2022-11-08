//
//  Data.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import Foundation

extension Data {
    public var hex: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}
