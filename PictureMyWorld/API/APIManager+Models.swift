//
//  APIManager+Models.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Alamofire

extension APIManager {

	/// Perform a GET request at the given Endpoint in order to fetch an array of dictionary.
	///
	/// - Parameters:
	///   - endpoint: Endpoint to fetch the data from.
	///   - completion: Completion block called after process.
	internal static func fetch(_ endpoint: Endpoint, completion: @escaping ((_ entities: [[AnyHashable: Any]], _ error: Error?) -> Void)) {
		guard let url = Environment.current.baseURL?.add(path: endpoint.rawValue) else {
			completion([], nil)
			return
		}

		APIManager.get(url).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			guard let json = result.json?[endpoint.jsonKey] as? [[AnyHashable: Any]] else {
				completion([], result.error)
				return
			}

			completion(json, nil)
		}
	}

	/// Perform a PUT or a POST request to create or update an entity at the given Endpoint.
	///
	/// - Parameters:
	///   - endpoint: Endpoint to perform the request at.
	///   - dictionary: Dictionary representing the entity. If 'filename' exists, an update (PUT) will be performed; otherwise create (POST).
	///   - completion: Completion block called after process.
	internal static func createOrUpdate(_ endpoint: Endpoint, with dictionary: [String: Any], completion: @escaping ((_ error: Error?) -> Void)) {
		guard let url = Environment.current.baseURL?.add(path: endpoint.rawValue) else {
			fatalError("Cannot create endpoint for: Country.createOrUpdateEntity")
		}

		let request = self.createOrUpdateRequest(for: url, with: dictionary)
		request.method(request.url, request.parameters, JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			if let error = result.error {
				completion(error)
			} else {
				completion(nil)
			}
		}
	}

	private typealias Request = (method: (URLConvertible, Parameters?, ParameterEncoding) -> DataRequest, url: URL, parameters: [String : Any])

	/// Create a PUT or POST Request representing either an "Update" or "Create" action.
	/// If 'filename' exists, an update (PUT) action will be performed and the its key/value pair removed from the request's parameters.
	///
	/// - Parameters:
	///   - url: Endpoint URL.
	///   - dictionary: Serialized entity with required parameters.
	/// - Returns: A new Request structure.
	private static func createOrUpdateRequest(for url: URL, with dictionary: [String: Any]) -> Request {
		var parameters = dictionary
		let filename = parameters[API.JSON.filename] as? String
		parameters.removeValue(forKey: API.JSON.filename)

		if
			let destination = filename,
			(destination.isEmpty == false),
			let updateEndpointURL = url.add(path: destination) {
				// UPDATE action
				return (APIManager.put, updateEndpointURL, parameters)
		} else {
			// CREATE action
			return (APIManager.post, url, parameters)
		}
	}

	/// Perform a DELETE request for a specific entity at the given Endpoint.
	///
	/// - Parameters:
	///   - endpoint: Endpoint to perform the request at.
	///   - filename: String property 'filename' of the model entity to delete.
	///   - completion: Completion block called after process.
	internal static func delete(_ endpoint: Endpoint, with filename: String, completion: @escaping ((_ error: Error?) -> Void)) {
		guard
			let endpoint = Environment.current.baseURL?.add(path: endpoint.rawValue),
			let deleteEndpoint = endpoint.add(path: filename) else {
				fatalError("Cannot create endpoint for: Country.createOrUpdateEntity")
		}

		APIManager.delete(deleteEndpoint).responseJSON { (response: DataResponse<Any>) in
			let result = APIManager.extractJSON(fromResponse: response)
			if let error = result.error {
				completion(error)
			} else {
				completion(nil)
			}
		}
	}
}
