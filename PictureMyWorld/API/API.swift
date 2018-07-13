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

		struct JSON {

			static let posts				= "posts"
		}
	}

	struct Endpoint {

		static let posts					= "posts"
		static let versions					= "versions"
	}
}
