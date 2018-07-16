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
	var image			: String
	var date			: String

	init(json: [AnyHashable: Any]) {
		self.latitude = (json[API.JSON.latitude] as? String ?? "")
		self.ratio = (json[API.JSON.ratio] as? String ?? "")
		self.longitude = (json[API.JSON.longitude] as? String ?? "")
		self.title = (json[API.JSON.title] as? String ?? "")
		self.caption = (json[API.JSON.caption] as? String ?? "")
		self.filename = (json[API.JSON.filename] as? String ?? "")
		self.locationText = (json[API.JSON.locationText] as? String ?? "")
		self.image = (json[API.JSON.image] as? String ?? "")
		self.date = (json[API.JSON.date] as? String ?? "")

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
			self.image.isEmpty == true ||
			self.date.isEmpty == true)
	}
}

extension Post: Serializable {

	var serialized: [AnyHashable: Any] {
		return [
			API.JSON.latitude: self.latitude,
			API.JSON.ratio: self.ratio,
			API.JSON.longitude: self.longitude,
			API.JSON.title: self.title,
			API.JSON.caption: self.caption,
			API.JSON.filename: self.filename,
			API.JSON.locationText: self.locationText,
			API.JSON.image: self.image,
			API.JSON.date: self.date
		]
	}
}
