//
//  AppDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import UIKit
import DKDBManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		DKDBManager.setupLocalDatabase()
		AssetManager.removeAllStoredAssets()
		return true
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		DKDBManager.cleanUp()
	}
}
