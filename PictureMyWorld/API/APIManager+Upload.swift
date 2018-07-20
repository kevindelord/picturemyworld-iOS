//
//  APIManager+Upload.swift
//  
//
//  Created by Kevin Delord on 20.07.18.
//

import Alamofire

struct UploadManager {

	private var url			: URL
	private var parameters	: [String: Any]
	private var imageData	: Data
	private var httpMethod	: HTTPMethod

	init(endpoint: Endpoint, with dictionary: [String: Any], imageData: Data) {
		// Image Data to Upload
		self.imageData = imageData
		// Request Parameters
		self.parameters = dictionary
		let filename = self.parameters[API.JSON.filename] as? String
		self.parameters.removeValue(forKey: API.JSON.filename)
		// PUT request for entity update, POST request to create new entity.
		self.httpMethod = (filename != nil && filename?.isEmpty == false ? .put : .post)
		// Configure the endpoint url.
		self.url = UploadManager.url(for: endpoint, with: filename)
	}

	private static func url(for endpoint: Endpoint, with filename: String?) -> URL {
		guard let url = Environment.current.baseURL?.add(path: endpoint.rawValue) else {
			fatalError("Cannot create endpoint for: Country.createOrUpdateEntity")
		}

		guard
			let destination = filename,
			(destination.isEmpty == false),
			let updateEndpointUrl = url.add(path: destination) else {
				// Create new entity
				return url
		}

		// Update existing entity
		return updateEndpointUrl
	}

	private func formData(multipartFormData: MultipartFormData) {
		for (key, value) in self.parameters {
			if let data = "\(value)".data(using: String.Encoding.utf8) {
				multipartFormData.append(data, withName: key as String)
			}
		}

		multipartFormData.append(self.imageData,
								 withName: API.JSON.image,
								 fileName: API.JSON.defaultImageName,
								 mimeType: API.MimeType.imageJPEG)
	}

	internal func upload(completion: @escaping ((_ error: Error?) -> Void)) {
		var headers = APIManager.authHeaders
		headers.contentType(.multipart)

		guard let request = try? URLRequest(url: self.url, method: self.httpMethod, headers: headers) else {
			completion(APIManager.errorWithMessage("Invalid URL for upload."))
			return
		}

		Alamofire.upload(multipartFormData: self.formData, with: request) { (result: SessionManager.MultipartFormDataEncodingResult) in
			switch result {
			case .success(let upload, _, _):
				upload.responseJSON { response in
					let result = APIManager.extractJSON(fromResponse: response)
					completion(result.error)
				}
			case .failure(let error):
				completion(error)
			}
		}
	}
}
