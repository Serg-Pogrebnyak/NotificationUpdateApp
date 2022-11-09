//
//  UIStoryboard.swift
//  NotificationUpdateApp
//
//  Created by Serhii on 09.11.2022.
//

import UIKit

extension UIStoryboard {
    func viewController<T>() -> T where T: UIViewController {
        instantiateViewController(withIdentifier: T.identifier) as! T
    }
}
