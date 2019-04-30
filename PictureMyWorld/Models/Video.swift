//
//  Video.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Video				: Model {

	var caption				: String
	var date				: String
	var filename			: String
	var music				: String
	var title				: String
	var youtubeIdentifier	: String

	init(json: [AnyHashable: Any]) {
		self.caption = (json[API.JSON.caption] as? String ?? "")
		self.date = (json[API.JSON.date] as? String ?? "")
		self.filename = (json[API.JSON.filename] as? String ?? "")
		self.music = (json[API.JSON.music] as? String ?? "")
		self.title = (json[API.JSON.title] as? String ?? "")
		self.youtubeIdentifier = (json[API.JSON.youtubeIdentifier] as? String ?? "")
	}

	var isInvalid: Bool {
		return (self.caption.isEmpty == true ||
			self.date.isEmpty == true ||
			self.filename.isEmpty == true ||
			self.music.isEmpty == true ||
			self.title.isEmpty == true ||
			self.youtubeIdentifier.isEmpty == true)
	}
}
