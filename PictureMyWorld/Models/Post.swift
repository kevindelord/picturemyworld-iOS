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
	}

	/// Extract the country from the complete location text.
	/// Pattern: <Area of Interest or Name>, <District>, <Country>
	var country			: String {
		let pattern = "[a-zA-Z-_ ]*$"
		var country = ""
		guard let range = self.locationText.range(of: pattern, options: .regularExpression) else {
			return ""
		}

		self.locationText.enumerateSubstrings(in: range) { (value: String?, start: Range<String.Index>, end: Range<String.Index>, stopEnumeration: inout Bool) in
			if let value = value {
				country = value.trimmingCharacters(in: .whitespacesAndNewlines)
				stopEnumeration = true
			}
		}

		return country
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
