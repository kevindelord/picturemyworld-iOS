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

	static func createOrUpdateEntity(with dictionary: [String: Any], completion: @escaping ((_ error: Error?) -> Void)) {
		APIManager.createOrUpdate(Self.entityEndpoint, with: dictionary, completion: completion)
	}

	static func deleteEntity(with dictionary: [String: Any], completion: @escaping ((_ error: Error?) -> Void)) {
		APIManager.delete(Self.entityEndpoint, with: dictionary, completion: completion)
	}
}
