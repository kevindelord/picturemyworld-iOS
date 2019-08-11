//
//  API.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation
import UIKit

struct API {

	enum ContentType {
		case urlEncoded
		case json
		case multipart

		var headerValue: String {
			switch self {
			case .urlEncoded	: return "application/x-www-form-urlencoded"
			case .json			: return "application/json"
			case .multipart		: return "multipart/form-data"
			}
		}

		static var headerKey = "Content-Type"
	}

	struct Error {

		static let domain				= "PictureMyWorld-iOS-Client_APIManager"
		static let code					= NSURLErrorUnknown

		struct Message {

			static let unknownError			= "An error occurred, please try again later."
			static let unauthorizedAccess	= "Unauthorized Access"
		}

	}

	struct Key {

		static let status				= "status"
		static let error				= "error"
		static let message				= "message"
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
		static let location 			= "location"
		static let link 				= "link"
		static let name 				= "name"
		static let image				= "image"
		static let imageFilename		= "image_filename"
		static let defaultImageName		= "image.jpg"
	}

	struct MimeType {

		static let imageJPEG			= "image/jpeg"
	}

	struct Upload {
		// Those values have been defined in the downscaling script written in Python.
		// See more at:
		//  - GitHub Repository: picturemyworld.github.io
		//  - File: `/scripts/create_image_post.py`
		//    > line 60: `convert %s -resize 2160x1440 -quality 40 %s`
		static let maximumImageSize		= CGSize(width: 2160.0, height: 1440.0)
	}
}

enum Endpoint							: String {

	case post							= "post"
	case posts							= "posts"
	case country						= "country"
	case countries						= "countries"
	case video							= "video"
	case videos							= "videos"
	case versions						= "versions"
	case deploy							= "deploy"

	enum Image							: String {

		case thumbnail					= "img/thumb"
		case large						= "img/large"
	}

	var jsonKey		 					: String {
		switch self {
		case .posts						: return "posts"
		case .countries					: return "countries"
		case .videos					: return "videos"
		default							: return ""
		}
	}
}
