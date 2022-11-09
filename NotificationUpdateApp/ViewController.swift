//
//  ViewController.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit
import ActivityKit

final class ViewController: UIViewController {

    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var devicesTableViewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.1, *) {
            startLiveActivity()
        }
    }

    @IBAction private func didTapSearchButton(_ sender: Any) {
        
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
}
