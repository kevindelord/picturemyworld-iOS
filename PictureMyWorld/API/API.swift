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
}

enum Endpoint							: String {

	case posts							= "posts"
	case countries						= "countries"
	case videos							= "videos"
	case versions						= "versions"

	var jsonKey		 					: String {
		switch self {
		case .posts						: return "posts"
		case .countries					: return "countries"
		case .videos					: return "videos"
		case .versions					: return ""
		}
	}
}
