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
		guard let endpoint = Environment.current.baseURL?.add(path: API.Endpoint.countries) else {
			completion([], nil)
			return
		}

		APIManager.get(endpoint).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			guard let json = result.json?[API.Key.JSON.countries] as? [[AnyHashable: Any]] else {
				completion([], result.error)
				return
			}

			let countries = CountryManager.createCountries(from: json)
			completion(countries, nil)
		}
	}

	private static func createCountries(from json: [[AnyHashable: Any]]) -> [Country] {
		return json.map { (data) -> Country in
			return Country(json: data)
		}
	}
}
