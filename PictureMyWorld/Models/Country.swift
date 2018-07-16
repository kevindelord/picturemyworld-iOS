//
//  Country.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Country		: Model {

	var filename	: String
	var link		: String
	var name		: String
	var image		: String
	var ratio		: String

	init(json: [AnyHashable: Any]) {
		self.ratio = (json[API.JSON.ratio] as? String ?? "")
		self.link = (json[API.JSON.link] as? String ?? "")
		self.filename = (json[API.JSON.filename] as? String ?? "")
		self.name = (json[API.JSON.name] as? String ?? "")
		self.image = (json[API.JSON.image] as? String ?? "")

		if (self.isInvalid == true) {
			fatalError("invalid country with json: \(json)")
		}
	}

	var isInvalid: Bool {
		return (self.ratio.isEmpty == true ||
			self.link.isEmpty == true ||
			self.filename.isEmpty == true ||
			self.name.isEmpty == true ||
			self.image.isEmpty == true)
	}
}
