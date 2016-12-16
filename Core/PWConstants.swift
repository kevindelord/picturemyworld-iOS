//
//  PWConstants.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 06/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import DKHelper

struct PWPlist {

	static let AppId            = "AppID"
	static let APIBaseURL       = "APIBaseURL"
	static let BuglifeID        = "BuglifeID"
}

struct Database {

	static let SqliteFilename				= "PictureMyWorld_iOS.sqlite"

	struct Key {

		struct Post {

			static let Timestamp			= "timestamp"
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

struct Interface {

	struct Slideshow {

		static let PreloadDelta				= 2
		static let BounceEffectZoomRatio	: CGFloat = 0.3
	}

	struct CollectionView {

		static let Inset		 			: CGFloat = 20.0
		static let MinimumItemWidth 		: CGFloat = 254.0
		static let DefaultRatio		 		= NSNumber(double: 0.75)
		static let MinComposentItemHeight	: CGFloat = 100.0
		static let DescriptionLabelInset	: CGFloat = 8.0
	}
}

extension HTMLParser {

	struct Key {

		static let ImageThumbnail			= "thumb"
		static let ImageLarge				= "large"
	}

	struct Regex {

		static let Filename					= "[0-9A-Za-z_-]+.[a-z]{3}$"
		static let Identifier				= "^[0-9A-Za-z_-]+"
	}

	static let DateFormat					= "MMMM dd, yyyy"
}

struct ReusableIdentifier {

	static let PostCollectionViewCell		= "PostCollectionViewCell_ID"
	static let InfoViewController			= "PWInfoViewController_ID"
}

extension UIColor {

	class func themeColor() -> UIColor {

		return (UIColor(fromHexString: "47A3DA") ?? UIColor.blueColor())
	}
}
