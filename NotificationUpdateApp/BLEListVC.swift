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
    
    var notificationManager: NotificationManager?
    
    private var peripheralSet: Set<CBPeripheral> = .init() { didSet { devicesTableViewList.reloadData() } }
    private var peripheralArray: [CBPeripheral] { Array(peripheralSet).sorted { ($0.name ?? .init()) > ($1.name ?? .init()) } }
    
    private let ble = BLE()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.1, *) {
            ActivityManager.shared.startActivity()
        }
        ble.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction private func didTapSearchButton(_ sender: Any) {
        guard ble.bluetoothState.canStartSearch else { return showBluetoothError() }
        guard ble.startSearchDevices() else { return }
        peripheralSet.removeAll()
        updateDeviceTableView(enabling: true)
    }
    
    private func updateDeviceTableView(enabling: Bool) {
        devicesTableViewList.isUserInteractionEnabled = enabling
        devicesTableViewList.visibleCells.forEach {
            $0.contentView.alpha = enabling ? 1 : 0.6
        }
    }
}

extension BLEListVC: BLEDelegate {
    func notifyThatFoundNewDeviceInScanningTime(device: CBPeripheral) {
        guard !(device.name?.isEmpty ?? true) else { return }
        peripheralSet.insert(device)
    }
    
    func didConnectToDevice() {
        guard let detailsVC: DetailsVC = storyboard?.viewController() else { return }
        detailsVC.notificationManager = notificationManager
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func didFailToConnectToDevice() {
        showAlert(withTitle: "Connection error",
                  message: "Didn't connect to device, please try again",
                  actions: [.init(title: "OK", style: .default)])
    }
}

extension BLEListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard peripheralArray.indices.contains(indexPath.row) else { return }
        ble.connectTo(device: peripheralArray[indexPath.row])
        updateDeviceTableView(enabling: false)
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
