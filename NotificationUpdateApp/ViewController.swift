//
//  ViewController.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit
import ActivityKit
import CoreBluetooth

final class ViewController: UIViewController {

    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var devicesTableViewList: UITableView!
    
    private var peripheralSet: Set<CBPeripheral> = .init() { didSet { devicesTableViewList.reloadData() } }
    private var peripheralArray: [CBPeripheral] { Array(peripheralSet) }
    
    private let ble = BLE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.1, *) {
            startLiveActivity()
        }
        ble.delegate = self
    }

    @IBAction private func didTapSearchButton(_ sender: Any) {
        guard ble.bluetoothState.canStartSearch else { return } //TODO: show error here
        guard ble.startSearchDevices() else { return }
        peripheralSet.removeAll()
    }
    
    @available(iOS 16.1, *)
    private func startLiveActivity() {
        let staticContent = NotificationLiveActivityAttributes(name: "Some name will be here")
        
        do {
            let deliveryActivity = try Activity<NotificationLiveActivityAttributes>.request(
                attributes: staticContent,
                contentState: .init(value: 0),
                pushType: .token)
            Task {
                for await activityPushToken in deliveryActivity.pushTokenUpdates {
                    print("live activity token: \(activityPushToken.hex)")
                }
            }
        } catch (let error) {
            print("Error requesting live activity \(error.localizedDescription)")
        }
    }
}

extension ViewController: BLEDelegate {
    func notifyThatFoundNewDeviceInScanningTime(device: CBPeripheral) {
        guard !(device.name?.isEmpty ?? true) else { return }
        peripheralSet.insert(device)
    }
    
    func didConnectToDevice() {
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peripheralArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard peripheralArray.indices.contains(indexPath.row) else { return .init() }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = peripheralArray[indexPath.row].name ?? .init()
        return cell
    }
}
