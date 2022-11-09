//
//  BLEListVC.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit
import CoreBluetooth

final class BLEListVC: UIViewController {

    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var devicesTableViewList: UITableView!
    
    private var peripheralSet: Set<CBPeripheral> = .init() { didSet { devicesTableViewList.reloadData() } }
    private var peripheralArray: [CBPeripheral] { Array(peripheralSet) }
    
    private let ble = BLE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if #available(iOS 16.1, *) {
            ActivityManager.shared.startActivity()
        }
        ble.delegate = self
    }

    @IBAction private func didTapSearchButton(_ sender: Any) {
        guard ble.bluetoothState.canStartSearch else { return showBluetoothError() }
        guard ble.startSearchDevices() else { return }
        peripheralSet.removeAll()
    }
}

extension BLEListVC: BLEDelegate {
    func notifyThatFoundNewDeviceInScanningTime(device: CBPeripheral) {
        guard !(device.name?.isEmpty ?? true) else { return }
        peripheralSet.insert(device)
    }
    
    func didConnectToDevice() {
        guard let detailsVC: DetailsVC = storyboard?.viewController() else { return }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension BLEListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard peripheralArray.indices.contains(indexPath.row) else { return }
        ble.connectTo(device: peripheralArray[indexPath.row])
    }
}

extension BLEListVC: UITableViewDataSource {
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
