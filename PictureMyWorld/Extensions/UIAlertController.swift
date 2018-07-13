//
//  UIAlertController.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 SMF. All rights reserved.
//

import UIKit

extension UIAlertController {

	class func showErrorPopup(_ error: NSError?, presentingViewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) {
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

	class func showErrorMessage(_ message: String, presentingViewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) {
		self.showInfoMessage("Error", message: message, presentingViewController: presentingViewController)
	}

	class func showInfoMessage(_ title: String, message: String, presentingViewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) {
		let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
		controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		presentingViewController?.present(controller, animated: true, completion: nil)
	}
}
