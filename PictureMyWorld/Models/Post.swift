//
//  Post.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

protocol Serializable {

	var serialized: [AnyHashable: Any] { get }
}

struct Post {

	var latitude		: String
	var ratio			: String
	var longitude		: String
	var title			: String
	var caption			: String
	var filename		: String
	var locationText	: String
	var photo			: String
	var date			: String

	init(json: [AnyHashable: Any]) {
		self.latitude = (json["latitude"] as? String ?? "")
		self.ratio = (json["ratio"] as? String ?? "")
		self.longitude = (json["longitude"] as? String ?? "")
		self.title = (json["title"] as? String ?? "")
		self.caption = (json["caption"] as? String ?? "")
		self.filename = (json["filename"] as? String ?? "")
		self.locationText = (json["location_text"] as? String ?? "")
		self.photo = (json["photo"] as? String ?? "")
		self.date = (json["date"] as? String ?? "")

		if (self.isInvalid == true) {
			fatalError("invalid post with json: \(json)")
		}
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

extension Post: Serializable {

	var serialized: [AnyHashable : Any] {
		return [
			"latitude": self.latitude,
			"ratio": self.ratio,
			"longitude": self.longitude,
			"title": self.title,
			"caption": self.caption,
			"filename": self.filename,
			"location_text": self.locationText,
			"photo": self.photo,
			"date": self.date
		]
	}
}
