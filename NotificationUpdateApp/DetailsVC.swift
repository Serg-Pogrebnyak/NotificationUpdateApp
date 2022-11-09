//
//  DetailsVC.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import UIKit

final class DetailsVC: UIViewController {
    
    @IBOutlet private weak var liveActivityStackView: UIStackView!
    @IBOutlet private weak var activityTokenLabel: UILabel!
    @IBOutlet private weak var liveActivityTerminalCommandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.1, *) {
            setupActivityDataToDisplay()
        } else {
            liveActivityStackView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Tokens details"
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction private func didTapCopyLiveActivityToken(_ sender: Any) {
        UIPasteboard.general.string = activityTokenLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    @IBAction private func didTapCopyLiveActivityCommand(_ sender: Any) {
        UIPasteboard.general.string = liveActivityTerminalCommandLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    @available(iOS 16.1, *)
    private func setupActivityDataToDisplay() {
        if let activityToken = ActivityManager.shared.activityToken {
            activityTokenLabel.text = activityToken
            liveActivityTerminalCommandLabel.text = "./updateDelivery.sh \(activityToken) \(Int.random(in: 0..<100))"
        } else {
            activityTokenLabel.text = "No activity token"
            liveActivityTerminalCommandLabel.text = "No activity token"
        }
    }
}
