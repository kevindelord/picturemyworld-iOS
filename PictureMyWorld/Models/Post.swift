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
		self.latitude = (json[API.JSON.Post.latitude] as? String ?? "")
		self.ratio = (json[API.JSON.Post.ratio] as? String ?? "")
		self.longitude = (json[API.JSON.Post.longitude] as? String ?? "")
		self.title = (json[API.JSON.Post.title] as? String ?? "")
		self.caption = (json[API.JSON.Post.caption] as? String ?? "")
		self.filename = (json[API.JSON.Post.filename] as? String ?? "")
		self.locationText = (json[API.JSON.Post.locationText] as? String ?? "")
		self.photo = (json[API.JSON.Post.photo] as? String ?? "")
		self.date = (json[API.JSON.Post.date] as? String ?? "")

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

	var serialized: [AnyHashable: Any] {
		return [
			API.JSON.Post.latitude: self.latitude,
			API.JSON.Post.ratio: self.ratio,
			API.JSON.Post.longitude: self.longitude,
			API.JSON.Post.title: self.title,
			API.JSON.Post.caption: self.caption,
			API.JSON.Post.filename: self.filename,
			API.JSON.Post.locationText: self.locationText,
			API.JSON.Post.photo: self.photo,
			API.JSON.Post.date: self.date
		]
	}
}
