//
//  UIViewController+NetworkAlert.swift
//  SportsApp
//
//  Created by Mazen Amr on 31/05/2026.
//

import Foundation

import UIKit

extension UIViewController {
    func showNetworkAlert() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.presentedViewController == nil else { return }
            
            let alert = UIAlertController(
                title: "offline_title".localized,
                message: "offline_message".localized,
                preferredStyle: .alert
            )
            
            let homeAction = UIAlertAction(title: "home_title".localized, style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(homeAction)
            self.present(alert, animated: true)
        }
    }
}
