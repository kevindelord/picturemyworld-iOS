//
//  APIManager.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 05/12/16.
//  Copyright © 2016 SMF. All rights reserved.
//

import Foundation
import Alamofire

extension Dictionary where Key == String, Value == String {

	mutating func contentType(_ contentType: API.ContentType) {
		self.updateValue(contentType.headerValue, forKey: API.ContentType.headerKey)
	}
}

/// Manager handling all API requests.
struct APIManager {

	/// Create valid authentification headers.
	public static var authHeaders: HTTPHeaders {
		guard
			let username = Environment.current.username,
			let password = Environment.current.password else {
				return [:]
		}

		let authorizationHeader = HTTPHeader.authorization(username: username, password: password)
		return HTTPHeaders([authorizationHeader])
	}

	/// Create a new Error object with a specific error message.
	///
	/// The error code used is `NSURLErrorUnknown`.
	///
	/// - Parameter message: Localized error message.
	/// - Returns: A new Error object.
	internal static func errorWithMessage(_ message: String) -> Error? {
		// As `Error` is just a protocol we need to use `NSError` to initialize a new Error instance.
		return NSError(domain: API.Error.domain, code: API.Error.code, userInfo: [NSLocalizedDescriptionKey: message])
	}

	/// Extract the JSON result from an API response.
	///
	/// - Parameter response: The DataResponse object coming from the API.
	/// - Returns: Tuple with the JSON or if any error occured `nil` and a valid Error object.
	internal static func extractJSON(fromResponse response: AFDataResponse<Any>) -> (json: [AnyHashable: Any]?, error: Error?) {
		var json: [AnyHashable: Any]?
		switch response.result {
		case .success(let value):
			json = (value as? [AnyHashable: Any])
		case .failure(let error):
			return (json: nil, error: error)
		}

		// Did request fail?
		if (json == nil && response.response?.statusCode == 401) {
			return (json: nil, error: APIManager.errorWithMessage(API.Error.Message.unauthorizedAccess))
		}

		// A request is invalid if an error message exists.
		if let errorMessage = json?[API.Key.message] as? String {
			return (json: json, error: APIManager.errorWithMessage(errorMessage.trim()))
		}

		// A request is invalid if a dictionary of errors has been received.
		if let errors = (json?[API.Key.message] as? [String: Any]) {
			if let message = errors[API.Key.message] as? String {
				return (json: json, error: APIManager.errorWithMessage(message.trim()))
			}

			if let error = errors.first {
				let errorMessage = "\(error.key): \(error.value as? String ?? "")"
				return (json: json, error: APIManager.errorWithMessage(errorMessage.trim()))
			}
		}

		// A request is invalid if its status is 'error'
		if let status = json?[API.Key.status] as? String, (status == API.Key.error) {
			return (json, error: APIManager.errorWithMessage(API.Error.Message.unknownError))
		}

		return (json: json, error: nil)
	}

	/// Perform a GET request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a GET endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func get(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		let headers = APIManager.authHeaders
		return AF.request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers)
	}

	/// Perform a POST request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a POST endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func post(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		var headers = APIManager.authHeaders
		let json = HTTPHeader.contentType(API.ContentType.json.headerValue)
		headers.add(json)
		return AF.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers)
	}

	/// Perform a PUT request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a POST endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func put(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		var headers = APIManager.authHeaders
		let json = HTTPHeader.contentType(API.ContentType.json.headerValue)
		headers.add(json)
		return AF.request(url, method: .put, parameters: parameters, encoding: encoding, headers: headers)
	}

	/// Perform a DELETE request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a POST endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func delete(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		let headers = APIManager.authHeaders
		return AF.request(url, method: .delete, parameters: parameters, encoding: encoding, headers: headers)
	}
}
