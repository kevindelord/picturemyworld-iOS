//
//  AppDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// AppCenter SDK Integration
		let appcenter_identifier = "5288d260-39ec-4ab9-b86e-a7830ab53a8e"
		MSAppCenter.start(appcenter_identifier, withServices:[MSAnalytics.self, MSCrashes.self])

		return true
	}
}
