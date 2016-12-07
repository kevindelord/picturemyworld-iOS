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

		self.setupDatabase()

		return true
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		DKDBManager.cleanUp()
	}

	private func setupDatabase() {
		DKDBManager.setVerbose(Verbose.Manager.Database)
		DKDBManager.setResetStoredEntities(Configuration.RestoreDatabaseOnStart)
		DKDBManager.setupDatabaseWithName(Database.SqliteFilename, didResetDatabase: {
			// Block executed when the database has been erased and created again.
			// Depending on your needs you might want to do something special right now as:.
			// - Setting up some user defaults.
			// - Deal with your api/store manager.
			// Etc.
		})
	}
}
