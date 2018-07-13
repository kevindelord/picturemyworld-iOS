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
		guard let endpoint = Environment.current.baseURL?.add(path: API.Endpoint.videos) else {
			completion([], nil)
			return
		}

		APIManager.get(endpoint).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			guard let json = result.json?[API.Key.JSON.videos] as? [[AnyHashable: Any]] else {
				completion([], result.error)
				return
			}

			let videos = VideoManager.createVideos(from: json)
			completion(videos, nil)
		}
	}

	private static func createVideos(from json: [[AnyHashable: Any]]) -> [Video] {
		return json.map { (data) -> Video in
			return Video(json: data)
		}
	}
}
