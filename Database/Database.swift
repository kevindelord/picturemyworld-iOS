//
//  Database.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 07/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import DKDBManager

extension DKDBManager {

	class func setupLocalDatabase() {
		DKDBManager.setVerbose(Verbose.Manager.Database)
		DKDBManager.setResetStoredEntities(Configuration.RestoreDatabaseOnStart)
		DKDBManager.setupDatabaseWithName(Database.SqliteFilename, didResetDatabase: {
			// Block executed when the database has been erased and created again.
			// Depending on your needs you might want to do something special right now as:.
			// - Setting up some user defaults.
			// - Deal with your api/store manager.
			// Etc.
			AssetManager.removeAllStoredAssets()
		})
	}

	class func crudPosts(postsArray: [[String: String]], completionBlock: (() -> Void)?) {
		DKDBManager.saveWithBlock({ (savingContext: NSManagedObjectContext) in

			// When reloading manually the posts, remove all stored identifiers.
			// By doing so, the logic to remove any potential deprecated entities will work perfectly.
			DKDBManager.removeAllStoredIdentifiers()
			// CRUD all the (new) posts.
			Post.crudEntitiesWithArray(postsArray, inContext: savingContext)
			// Check and remove any potential deprecated post (i.e. has been removed from the web page).
			DKDBManager.removeDeprecatedEntitiesInContext(savingContext)
		}, completion: { (contextDidSave: Bool, error: NSError?) in
			completionBlock?()
		})
	}
}
