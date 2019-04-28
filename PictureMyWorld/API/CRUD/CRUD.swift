//
//  PostManager.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 12/02/17.
//  Copyright © 2017 SMF. All rights reserved.
//

import Foundation
import Alamofire

protocol CRUD {

	static var entitiesEndpoint : Endpoint { get }

	static var entityEndpoint : Endpoint { get }
}

extension CRUD where Self: Model {

	static func fetchEntities(completion: @escaping ((_ posts: [Self], _ error: Error?) -> Void)) {
		APIManager.fetch(Self.entitiesEndpoint, completion: { (json: [[AnyHashable: Any]], error: Error?) in
			let posts = json.map { (data) -> Self in
				return Self(json: data)
			}

			completion(posts, error)
		})
	}

	static func createOrUpdateEntity(with dictionary: [String: Any], imageData: Data?, completion: @escaping ((_ error: Error?) -> Void)) {
		if let imageData = imageData {
			// Create or update an entity with an image to upload.
			let uploadManager = UploadManager(endpoint: Self.entityEndpoint, with: dictionary, imageData: imageData)
			uploadManager.upload(completion: completion)
		} else {
			// Create or update an entity without uploading any image.
			APIManager.createOrUpdate(Self.entityEndpoint, with: dictionary, completion: completion)
		}
	}

	static func deleteEntity(with filename: String, completion: @escaping ((_ error: Error?) -> Void)) {
		APIManager.delete(Self.entityEndpoint, with: filename, completion: completion)
	}
}
