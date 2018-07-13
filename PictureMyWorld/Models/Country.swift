//
//  Country.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Country {

	var filename	: String
	var link		: String
	var name		: String
	var photo		: String
	var ratio		: String

	init(json: [AnyHashable: Any]) {
		self.ratio = (json["ratio"] as? String ?? "")
		self.link = (json["link"] as? String ?? "")
		self.filename = (json["filename"] as? String ?? "")
		self.name = (json["name"] as? String ?? "")
		self.photo = (json["photo"] as? String ?? "")

		if (self.isInvalid == true) {
			fatalError("invalid country with json: \(json)")
		}
	}

	var isInvalid: Bool {
		return (self.ratio.isEmpty == true ||
			self.link.isEmpty == true ||
			self.filename.isEmpty == true ||
			self.name.isEmpty == true ||
			self.photo.isEmpty == true)
	}
}
