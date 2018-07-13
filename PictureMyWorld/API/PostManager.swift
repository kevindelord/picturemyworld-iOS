//
//  PostManager.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 12/02/17.
//  Copyright © 2017 SMF. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Apps API

struct PostManager {

	/// Fetch available App info.
	///
	/// - Parameter completion: Completion Closure executed at the end of the fetch request.
	static func fetchEntities(completion: @escaping ((_ posts: [Post], _ error: Error?) -> Void)) {
		guard let endpoint = Environment.current.baseURL?.add(path: API.Endpoint.posts) else {
			completion([], nil)
			return
		}

		APIManager.get(endpoint).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			guard let json = result.json?[API.Key.JSON.posts] as? [[AnyHashable: Any]] else {
				completion([], result.error)
				return
			}

			let posts = PostManager.posts(from: json)
			completion(posts, nil)
		}
	}

	private static func posts(from json: [[AnyHashable: Any]]) -> [Post] {
		return json.map { (data) -> Post in
			return Post(json: data)
		}
	}
}
