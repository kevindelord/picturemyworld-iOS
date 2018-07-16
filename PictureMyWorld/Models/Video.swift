//
//  Video.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Video {

	var caption				: String
	var date				: String
	var filename			: String
	var music				: String
	var title				: String
	var youtubeIdentifier	: String

	init(json: [AnyHashable: Any]) {
		self.caption = (json["caption"] as? String ?? "")
		self.date = (json["date"] as? String ?? "")
		self.filename = (json["filename"] as? String ?? "")
		self.music = (json["music"] as? String ?? "")
		self.title = (json["title"] as? String ?? "")
		self.youtubeIdentifier = (json["youtube_id"] as? String ?? "")

		if (self.isInvalid == true) {
			fatalError("invalid video with json: \(json)")
		}
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

extension Video: Serializable {

	var serialized: [AnyHashable : Any] {
		return [
			"caption": self.caption,
			"date": self.date,
			"filename": self.filename,
			"music": self.music,
			"title": self.title,
			"youtube_id": self.youtubeIdentifier
		]
	}
}
