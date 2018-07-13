//
//  VideoManager.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation
import Alamofire

struct VideoManager {

	/// Fetch available App info.
	///
	/// - Parameter completion: Completion Closure executed at the end of the fetch request.
	static func fetchEntities(completion: @escaping ((_ posts: [Video], _ error: Error?) -> Void)) {
		APIManager.fetchArray(endpoint: .videos, completion: { (json: [[AnyHashable: Any]], error: Error?) in
			let videos = json.map { (data) -> Video in
				return Video(json: data)
			}

			completion(videos, error)
		})
	}
}