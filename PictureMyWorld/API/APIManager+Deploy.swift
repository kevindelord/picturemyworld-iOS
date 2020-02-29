//
//  APIManager+Deploy.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import Foundation
import Alamofire

extension APIManager {

	/// Deploy changes to the given environment.
	///
	/// - Parameters:
	///   - environment: Environment to deploy active changes to.
	///   - completion: Completion closure called after execution.
	static func deployChanges(to environment: Environment, completion: @escaping ((_ error: Error?) -> Void)) {
		guard
			let baseURL = Environment.current.baseURL,
			let deployEndpoint = baseURL.add(path: Endpoint.deploy.rawValue),
			let endpoint = deployEndpoint.add(path: environment.key) else {
				completion(nil)
				return
		}

		APIManager.put(endpoint).responseJSON { (response: AFDataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			completion(result.error)
		}
	}
}
