//
//  VersionManager.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation
import Alamofire

struct VersionManager {

	/// Fetch available App info.
	///
	/// - Parameter completion: Completion Closure executed at the end of the fetch request.
	static func fetch(completion: @escaping ((_ versions: [Environment: String], _ error: Error?) -> Void)) {
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

	private static func displayDeployedVersions(_ versions: [Environment: String]) {
		// Sort the result and generate a description string.
		let environments = versions.keys.sorted { (lhs: Environment, rhs: Environment) -> Bool in
			return (lhs.rawValue < rhs.rawValue)
		}

		var versionString = ""
		for environment in environments {
			versionString += "\(environment.key): \(versions[environment] ?? "")\n\n"
		}

		// Remove last 2 "\n"
		versionString.removeLast(2)
		UIAlertController.showInfoMessage("", message: versionString)
	}

	static func presentDeployedVersion() {
		VersionManager.fetch(completion: { (versions: [Environment: String], error: Error?) in
			if let error = error {
				UIAlertController.showErrorMessage(error.localizedDescription)
			} else {
				VersionManager.displayDeployedVersions(versions)
			}
		})
	}
}
