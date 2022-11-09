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
    @IBOutlet private weak var pushNotificationTokenLabel: UILabel!
    @IBOutlet private weak var notificationTokenTerminalCommandLabel: UILabel!
    
    var notificationManager: NotificationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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
    
    @IBAction private func didTapPushNotificationToken(_ sender: Any) {
        UIPasteboard.general.string = pushNotificationTokenLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    @IBAction private func didTapCopyPushNotificationCommand(_ sender: Any) {
        UIPasteboard.general.string = notificationTokenTerminalCommandLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    private func setup() {
        // Live activity stuff
        if #available(iOS 16.1, *) {
            setupActivityDataToDisplay()
            ActivityManager.shared.delegate = self
        } else {
            liveActivityStackView.isHidden = true
        }
        
        // Push notification stuff
        notificationManager?.delegate = self
        displayPushNotificationToken()
    }
    
    @available(iOS 16.1, *)
    private func setupActivityDataToDisplay() {
        if let activityToken = ActivityManager.shared.activityToken {
            activityTokenLabel.text = activityToken
            liveActivityTerminalCommandLabel.text = "sh ./sendUpdateToLiveActivity.sh \(activityToken) \(Int.random(in: 0..<100))"
        } else {
            activityTokenLabel.text = "No activity token"
            liveActivityTerminalCommandLabel.text = "No activity token"
        }
    }
    
    private func displayPushNotificationToken() {
        if let pushToken = notificationManager?.token {
            pushNotificationTokenLabel.text = pushToken
            notificationTokenTerminalCommandLabel.text = "sh ./sendPushWithCollapseId.sh \(pushToken) \(Int.random(in: 0..<100))"
        } else {
            pushNotificationTokenLabel.text = "No push notification token"
            notificationTokenTerminalCommandLabel.text = "No push notification token"
        }
    }
}

extension DetailsVC: ActivityManagerDelegate {
    func didReceiveNewToken(_ token: String) {
        if #available(iOS 16.1, *) {
            setupActivityDataToDisplay()
        }
    }
}

extension DetailsVC: NotificationManagerDelegate {
    func tokenDidChange(_ token: String) {
        displayPushNotificationToken()
    }
}
