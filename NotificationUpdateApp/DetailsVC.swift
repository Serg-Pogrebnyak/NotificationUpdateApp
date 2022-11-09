//
//  DetailsVC.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import UIKit

final class DetailsVC: UIViewController {
    
    @IBOutlet private weak var activityTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.1, *) {
            activityTokenLabel.text = ActivityManager.shared.activityToken ?? "No activity token"
        } else {
            activityTokenLabel.isHidden = true
        }
    }
    
}
