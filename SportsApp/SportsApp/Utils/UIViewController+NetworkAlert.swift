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
                title: "Offline",
                message: "No internet connection detected. Returning to Home.",
                preferredStyle: .alert
            )
            
            let homeAction = UIAlertAction(title: "Home", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(homeAction)
            self.present(alert, animated: true)
        }
    }
}
