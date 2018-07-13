//
//  APIManager.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 05/12/16.
//  Copyright © 2016 SMF. All rights reserved.
//

import Foundation
import Alamofire

struct API {

	struct Error {

		static let domain					= "PictureMyWorld-iOS-Client_APIManager"
		static let code						= NSURLErrorUnknown
	}

	struct Key {

		static let status					= "status"
		static let error					= "error"
		static let reason					= "reason"
		static let errors					= "errors"
		static let credentials				= "credentials"

		struct JSON {

			static let posts				= "posts"
		}
	}

	struct Endpoint {

		static let posts					= "posts"
		static let versions					= "versions"
	}
}

/// Manager handling all API requests.
struct APIManager {

	/// Create valid authentification headers.
	///
	/// - Parameters:
	///   - emailAddress: String email address to use in the authentification proccess.
	///   - password: String password to use in the authentification proccess.
	/// - Returns: Authentification headers for POST requests.
	public static var authHeaders: HTTPHeaders {
		guard
			let username = Environment.current.username,
			let password = Environment.current.password,
			let authData = "\(username):\(password)".data(using: String.Encoding.utf8, allowLossyConversion: false) else {
				return [:]
		}

		let authValue = String(format: "Basic %@", authData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters))
		return ["Authorization": authValue]
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
	internal static func extractJSON(fromResponse response: DataResponse<Any>) -> (json: [AnyHashable: Any]?, error: Error?) {
		let json = response.result.value as? [AnyHashable: Any]

		// Did request fail?
		if (json == nil), let error = response.result.error {
			return (json: nil, error: error)
		}

		// Did credential fail?
		if let errorMessage = ((json?[API.Key.errors] as? [AnyHashable: Any])?[API.Key.credentials] as? [String])?.first {
			return (json: nil, error: APIManager.errorWithMessage(errorMessage))
		}

		// Was the request invalid?
		if
			let errorMessage = json?[API.Key.reason] as? String,
			let status = json?[API.Key.status] as? String, (status == API.Key.error) {
				return (json: nil, error: APIManager.errorWithMessage(errorMessage))
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
		print("endpoint: \(url)")
		print("authHeaders: \(headers)")
		return Alamofire.request(url, method: .get, parameters: parameters, encoding: encoding, headers: headers)
	}

	/// Perform a POST request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a POST endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func post(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		let headers = APIManager.authHeaders
		return Alamofire.request(url, method: .post, parameters: parameters, encoding: encoding, headers: headers)
	}

	/// Perform a PUT request to the API.
	///
	/// - Parameters:
	///   - url: Valid web URL to a POST endpoint.
	///   - parameters: The web parameters for the request.
	///   - encoding: The parameter encoding; JSONEncoding.default by default.
	/// - Returns: The created `DataRequest` object used to extract the JSON response.
	internal static func put(_ url: URLConvertible, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
		let headers = APIManager.authHeaders
		return Alamofire.request(url, method: .put, parameters: parameters, encoding: encoding, headers: headers)
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
		return Alamofire.request(url, method: .delete, parameters: parameters, encoding: encoding, headers: headers)
	}
}
