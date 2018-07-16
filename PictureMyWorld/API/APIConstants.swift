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
		static let message					= "message"
		static let errors					= "errors"
		static let credentials				= "credentials"
	}

	struct JSON {

		static let caption				= "caption"
		static let date					= "date"
		static let filename				= "filename"
		static let music 				= "music"
		static let title				= "title"
		static let youtubeIdentifier	= "youtube_id"
		static let latitude 			= "latitude"
		static let ratio 				= "ratio"
		static let longitude 			= "longitude"
		static let locationText 		= "location_text"
		static let image				= "image"
		static let link 				= "link"
		static let name 				= "name"

	}
}

enum Endpoint								: String {

	case post								= "post"
	case posts								= "posts"
	case country							= "country"
	case countries							= "countries"
	case video								= "video"
	case videos								= "videos"
	case versions							= "versions"

	var jsonKey		 						: String {
		switch self {
		case .posts							: return "posts"
		case .countries						: return "countries"
		case .videos						: return "videos"
		default								: return ""
		}
	}
}
