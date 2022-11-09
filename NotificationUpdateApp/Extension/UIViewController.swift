//
//  UIViewController.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import UIKit

extension UIViewController {
    func showBluetoothError() {
        showAlert(withTitle: "Bluetooth error",
                  message: "Bluetooth turn off or Bluetooth permission denied",
                  actions: [.init(title: "OK", style: .default)])
    }
    
    func showAlert(withTitle title: String, message: String = .init(), actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
       
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}
