//
//  AppDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
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
