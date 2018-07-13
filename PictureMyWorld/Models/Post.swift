//
//  Post.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Post {

	public var latitude			: String
	public var ratio			: String
	public var longitude		: String
	public var title			: String
	public var caption			: String
	public var filename			: String
	public var locationText		: String
	public var photo			: String
	public var date				: String

	init(hash: [AnyHashable: Any]) {
		self.latitude = (hash["latitude"] as? String ?? "")
		self.ratio = (hash["ratio"] as? String ?? "")
		self.longitude = (hash["longitude"] as? String ?? "")
		self.title = (hash["title"] as? String ?? "")
		self.caption = (hash["caption"] as? String ?? "")
		self.filename = (hash["filename"] as? String ?? "")
		self.locationText = (hash["location_text"] as? String ?? "")
		self.photo = (hash["photo"] as? String ?? "")
		self.date = (hash["date"] as? String ?? "")
	}

	var isInvalid: Bool {
		return (self.latitude.isEmpty == true ||
			self.ratio.isEmpty == true ||
			self.longitude.isEmpty == true ||
			self.title.isEmpty == true ||
			self.caption.isEmpty == true ||
			self.filename.isEmpty == true ||
			self.locationText.isEmpty == true ||
			self.photo.isEmpty == true ||
			self.date.isEmpty == true)
	}
}
