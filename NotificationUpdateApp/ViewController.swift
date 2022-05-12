//
//  ViewController.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 12.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = UIApplication.shared.delegate as! AppDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(options: authOptions) { _,_ in }
        UIApplication.shared.registerForRemoteNotifications()
    }

}


