//
//  PWConstants.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 06/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation

struct Database {

	static let SqliteFilename				= "PictureMyWorld_iOS.sqlite"

	struct Key {

		struct Post {

			static let Identifier			= "identifier"
			static let Title                = "title"
			static let DescriptionText 		= "descriptionText"
			static let MapsLink 			= "mapsLink"
			static let MapsText 			= "mapsText"
			static let DateString 			= "dateString"
			static let Date		 			= "date"
			static let ThumbnailURL 		= "thumbnailURL"
			static let ImageURL 			= "imageURL"
		}
	}
}

struct API {

	static let BaseURL						= "http://picturemy.world"
}
