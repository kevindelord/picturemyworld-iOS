//
//  Post.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import DKDBManager
import DKHelper

class Post: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

// MARK: - DKDBManager

extension Post {

	override var description: String {
		return "\(self.title ?? "nil"): \(self.date ?? "nil"), location: \(self.mapsText ?? ""))"
	}

	override func updateWithDictionary(dictionary: [NSObject: AnyObject]?, inContext savingContext: NSManagedObjectContext) {
		super.updateWithDictionary(dictionary, inContext: savingContext)

		self.identifier			= dictionary?[Database.Key.Post.Identifier] as? String
		self.title				= dictionary?[Database.Key.Post.Title] as? String
		self.descriptionText	= dictionary?[Database.Key.Post.DescriptionText] as? String
		self.mapsLink			= dictionary?[Database.Key.Post.MapsLink] as? String
		self.mapsText			= dictionary?[Database.Key.Post.MapsText] as? String
		self.dateString			= dictionary?[Database.Key.Post.DateString] as? String
		self.thumbnailURL		= dictionary?[Database.Key.Post.ThumbnailURL] as? String
		self.imageURL			= dictionary?[Database.Key.Post.ImageURL] as? String
		self.date 				= GET_DATE(dictionary, Database.Key.Post.Date)
	}

	override class func verbose() -> Bool {
		return Verbose.Database.Post
	}

	override class func sortingAttributeName() -> String? {
		return Database.Key.Post.Date
	}

	override func deleteEntityWithReason(reason: String?, inContext savingContext: NSManagedObjectContext) {
		AssetManager.removeCachedImage(self.thumbnailURL)

		super.deleteEntityWithReason(reason, inContext: savingContext)
	}

	override class func primaryPredicateWithDictionary(dictionary: [NSObject: AnyObject]?) -> NSPredicate? {
		if let identifier = dictionary?[Database.Key.Post.Identifier] as? String {
			return NSPredicate(format: "%K == %@", Database.Key.Post.Identifier, identifier)
		}
		return super.primaryPredicateWithDictionary(dictionary)
	}
}
