//
//  APIManager+Versions.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation
import Alamofire

extension APIManager {

	/// Fetch deployed versions.
	///
	/// - Parameter completion: Completion Closure executed at the end of the fetch request.
	static func fetchVersions(completion: @escaping ((_ versions: [Environment: String], _ error: Error?) -> Void)) {
		guard let endpoint = Environment.current.baseURL?.add(path: Endpoint.versions.rawValue) else {
			completion([:], nil)
			return
		}

		APIManager.get(endpoint).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			guard let json = result.json else {
				completion([:], result.error)
				return
			}

			var versions = [Environment: String]()
			for env in Environment.allCases {
				if let version = json[env.key] as? String {
					versions[env] = version
				}
			}

			completion(versions, result.error)
		}
	}
}
