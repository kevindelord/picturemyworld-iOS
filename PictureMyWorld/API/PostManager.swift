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
		APIManager.fetchArray(endpoint: .posts, completion: { (json: [[AnyHashable: Any]], error: Error?) in
			let posts = json.map { (data) -> Post in
				return Post(json: data)
			}

			completion(posts, error)
		})
	}
}
