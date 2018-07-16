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
		self.ratio = (json[API.JSON.Country.ratio] as? String ?? "")
		self.link = (json[API.JSON.Country.link] as? String ?? "")
		self.filename = (json[API.JSON.Country.filename] as? String ?? "")
		self.name = (json[API.JSON.Country.name] as? String ?? "")
		self.photo = (json[API.JSON.Country.photo] as? String ?? "")

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

extension Country: Serializable {

	var serialized: [AnyHashable : Any] {
		return [
			API.JSON.Country.filename: self.filename,
			API.JSON.Country.name: self.name,
			API.JSON.Country.photo: self.photo,
			API.JSON.Country.link: self.link,
			API.JSON.Country.ratio: self.ratio
		]
	}
}
