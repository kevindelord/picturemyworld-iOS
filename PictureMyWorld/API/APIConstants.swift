//
//  API.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct API {

	struct Error {

		static let domain					= "PictureMyWorld-iOS-Client_APIManager"
		static let code						= NSURLErrorUnknown
	}

	struct Key {

		static let status					= "status"
		static let error					= "error"
		static let reason					= "reason"
		static let errors					= "errors"
		static let credentials				= "credentials"
	}

	struct JSON {

		struct Video {

			static let caption				= "caption"
			static let date					= "date"
			static let filename				= "filename"
			static let music 				= "music"
			static let title				= "title"
			static let youtubeIdentifier	= "youtube_id"
		}

		struct Post {

			static let latitude 			= "latitude"
			static let ratio 				= "ratio"
			static let longitude 			= "longitude"
			static let title 				= "title"
			static let caption 				= "caption"
			static let filename 			= "filename"
			static let locationText 		= "location_text"
			static let photo 				= "photo"
			static let date 				= "date"
			static let image				= "image"
		}

		struct Country {

			static let ratio 				= "ratio"
			static let link 				= "link"
			static let filename 			= "filename"
			static let name 				= "name"
			static let photo 				= "photo"
		}
	}
}

enum Endpoint								: String {

	case posts								= "posts"
	case countries							= "countries"
	case videos								= "videos"
	case versions							= "versions"

	var jsonKey		 						: String {
		switch self {
		case .posts							: return "posts"
		case .countries						: return "countries"
		case .videos						: return "videos"
		case .versions						: return ""
		}
	}
}
