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

	class func allEntities() -> [Post] {
		return (Post.MR_findAllSortedBy(Database.Key.Post.Timestamp, ascending: false) as? [Post] ?? [])
	}

	var validThumbnailRatio: CGFloat {
		get {
			var imageRatio = Interface.CollectionView.DefaultRatio
			if let ratio = self.thumbnailRatio where (ratio != 0) {
				imageRatio = ratio
			}
			return CGFloat(imageRatio)
		}
		set {
			if (self.thumbnailRatio == nil || self.thumbnailRatio?.isEqualToNumber(0) == true) {
				DKDBManager.saveWithBlock { (savingContext: NSManagedObjectContext) in
					if let post = self.entityInContext(savingContext) {
						post.thumbnailRatio = newValue
					}
				}
			}
		}
	}
}

// MARK: - DKDBManager

extension Post {

	override var description: String {
		return "'\(self.title ?? "nil")': \(self.dateString ?? "nil"), location: \(self.mapsText ?? "")"
	}

	override func updateWithDictionary(dictionary: [NSObject: AnyObject]?, inContext savingContext: NSManagedObjectContext) {
		super.updateWithDictionary(dictionary, inContext: savingContext)

		self.timestamp			= dictionary?[Database.Key.Post.Timestamp] as? String
		self.title				= dictionary?[Database.Key.Post.Title] as? String
		self.descriptionText	= dictionary?[Database.Key.Post.DescriptionText] as? String
		self.mapsLink			= dictionary?[Database.Key.Post.MapsLink] as? String
		self.mapsText			= dictionary?[Database.Key.Post.MapsText] as? String
		self.dateString			= dictionary?[Database.Key.Post.DateString] as? String
		self.thumbnailURL		= dictionary?[Database.Key.Post.ThumbnailURL] as? String
		self.imageURL			= dictionary?[Database.Key.Post.ImageURL] as? String
		self.date 				= NSDate(fromISOString: (dictionary?[Database.Key.Post.Date] as? String) ?? "")

		// Remove extra whitespace and newline characters.
		self.mapsText 			= self.mapsText?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		self.descriptionText 	= self.descriptionText?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		self.title 				= self.title?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}

	override class func verbose() -> Bool {
		return Verbose.Database.Post
	}

	override func invalidReason() -> String? {

		guard
			((self.timestamp != nil) &&
				(self.title != nil) &&
				(self.descriptionText != nil) &&
				(self.mapsLink != nil) &&
				(self.mapsText != nil) &&
				(self.dateString != nil) &&
				(self.thumbnailURL != nil) &&
				(self.imageURL != nil) &&
				(self.date != nil)) else {
					// If one value is missing, invalid the data and ignore the post
					return "Missing value"
		}

		return super.invalidReason()
	}

	override class func sortingAttributeName() -> String? {
		return Database.Key.Post.Timestamp
	}

	override func deleteEntityWithReason(reason: String?, inContext savingContext: NSManagedObjectContext) {
		AssetManager.removeCachedImage(self.thumbnailURL)

		super.deleteEntityWithReason(reason, inContext: savingContext)
	}

	override class func primaryPredicateWithDictionary(dictionary: [NSObject: AnyObject]?) -> NSPredicate? {
		if let identifier = dictionary?[Database.Key.Post.Timestamp] as? String {
			return NSPredicate(format: "%K == %@", Database.Key.Post.Timestamp, identifier)
		}
		return super.primaryPredicateWithDictionary(dictionary)
	}
}
