//
//  UIAlertController.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 SMF. All rights reserved.
//

import UIKit

extension UIAlertController {

	class func showErrorPopup(_ error: NSError?, presentingViewController: UIViewController? = nil) {
		// Find a valid message to display
		var message : String? = nil
		if let errorMessage : String = error?.userInfo[API.Key.error] as? String {
			message = errorMessage
		} else if let errorMessage = error?.localizedFailureReason {
			message = errorMessage
		} else if let errorMessage = error?.localizedDescription, (errorMessage.isEmpty == false) {
			message = errorMessage
		}

		// Show a popup
		if let errorMessage = message {
			self.showErrorMessage(errorMessage, presentingViewController: presentingViewController)
		}
	}

	class func showErrorMessage(_ message: String, presentingViewController: UIViewController? = nil) {
		self.showInfoMessage("Error", message: message, presentingViewController: presentingViewController)
	}

	class func showInfoMessage(_ title: String, message: String, presentingViewController: UIViewController? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

		// Present the UIAlertController
		let controller = (presentingViewController ?? AppDelegate.alertPresentingController)
		controller?.present(alertController, animated: true, completion: nil)
	}
}

extension AppDelegate {

	/// ViewController on which an alert controller should be presented.
	class var alertPresentingController: UIViewController? {

		let rootController = UIApplication.shared.windows.first?.rootViewController

		guard var lastViewController = rootController?.presentedViewController else {
			return rootController
		}

		repeat {
			if let viewController = lastViewController.presentedViewController {
				lastViewController = viewController
			}
		} while (lastViewController.presentedViewController != nil)

		return lastViewController
	}
}
