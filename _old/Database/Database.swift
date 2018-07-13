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

	/**
	Setup, and reset if needed, the datamodel using an auto migrating system.
	*/
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

	/**
	CRUD new Post model objects.

	- parameter postsArray:      An array of dictionaries representing the posts.
	- parameter completionBlock: Completion block executed after the database saved to the persistent store.
	*/
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
			if let _error = error {
				print(_error)
			}
			// Preload all thumbnail images.
			self.preloadAllThumbnails()
			// Call the completion block.
			completionBlock?()
		})
	}

	/**
	Preload all thumbnail images.
	This function also calculates and stores the image ratio into the local persistent store.
	An image is usually about 20kb. This will not kill the device memory.
	*/
	private class func preloadAllThumbnails() {
		for post in Post.allEntities() {
			if (post.thumbnailRatio == nil) {
				AssetManager.downloadImage(post.thumbnailURL, priority: DownloadPriority.Low, completion: { (image: UIImage?) in
					if let image = image {
						post.validThumbnailRatio = (image.size.height / image.size.width)
					}
				})
			}
		}
	}
}