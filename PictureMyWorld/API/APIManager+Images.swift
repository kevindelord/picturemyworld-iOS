//
//  APIManager+Images.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

extension APIManager {

	static func downloadAndCache(_ endpoint: Endpoint.Image, for image: String, completion: @escaping ((UIImage?) -> Void)) {
		guard
			let baseUrl = Environment.current.baseURL,
			let sizeUrl = baseUrl.add(path: endpoint.rawValue),
			let imageUrl = sizeUrl.add(path: image) else {
				completion(nil)
				return
		}

		AssetManager.APIUsername = Environment.current.username
		AssetManager.APIPassword = Environment.current.password
		AssetManager.downloadImage(fromURL: imageUrl, priority: .high, completion: completion)
	}
}

