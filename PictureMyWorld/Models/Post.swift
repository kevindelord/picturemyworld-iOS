//  Post.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Post				: Model {

	var latitude		: String
	var ratio			: String
	var longitude		: String
	var title			: String
	var caption			: String
	var filename		: String
	var locationText	: String
	var country			: String
	var image			: String
	var date			: String

	init(json: [AnyHashable: Any]) {
		self.latitude = (json[API.JSON.latitude] as? String ?? "")
		self.ratio = (json[API.JSON.ratio] as? String ?? "")
		self.longitude = (json[API.JSON.longitude] as? String ?? "")
		self.title = (json[API.JSON.title] as? String ?? "")
		self.caption = (json[API.JSON.caption] as? String ?? "")
		self.filename = (json[API.JSON.filename] as? String ?? "")
		self.image = (json[API.JSON.image] as? String ?? "")
		self.date = (json[API.JSON.date] as? String ?? "")

		let location = Post.extractLocation(from: json)
		self.locationText = location.address
		self.country = location.country
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

extension Post {
	/// Extract the country from the complete location text.
	/// Pattern: <Area of Interest or Name>, <District>, <Country>
	private static func extractLocation(from json: [AnyHashable: Any]) -> (country: String, address: String) {
		var components = (json[API.JSON.locationText] as? String ?? "").components(separatedBy: ", ")
		let country = (components.popLast() ?? "")
		let address = components.joined(separator: ", ")
		return (country: country, address: address)
	}
}
