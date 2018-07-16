//
//  CountryManager.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation
import Alamofire

struct CountryManager {

	/// Fetch available App info.
	///
	/// - Parameter completion: Completion Closure executed at the end of the fetch request.
	static func fetchEntities(completion: @escaping ((_ posts: [Country], _ error: Error?) -> Void)) {
		APIManager.fetchArray(endpoint: .countries, completion: { (json: [[AnyHashable: Any]], error: Error?) in
			let countries = json.map { (data) -> Country in
				return Country(json: data)
			}

			completion(countries, error)
		})
	}

	static func updateEntity(with dictionary: [AnyHashable: Any], completion: @escaping (_ error: Error?) -> Void) {
		completion(nil)
	}

	static func createEntity(with dictionary: [AnyHashable: Any], completion: @escaping (_ error: Error?) -> Void) {
		completion(nil)
	}
}
