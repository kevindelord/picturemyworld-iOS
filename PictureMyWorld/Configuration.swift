//
//  Configuration.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

struct Configuration {

	static let _configuration = Configuration.setup()

	static func setup() -> NSDictionary {
		var configuration: NSDictionary?
		if let path = Bundle.main.path(forResource: "credentials", ofType: "plist") {
			configuration = NSDictionary(contentsOfFile: path)
		}

		return (configuration ?? NSDictionary())
	}

	public enum SupportedEnvironmentName : String {

		case development 	= "development"
		case staging 		= "staging"
		case producation	= "production"
	}

	public enum Keys		: String {

		case baseURL 		= "base_url"
		case webURL 		= "web_url"
		case username 		= "username"
		case password 		= "password"
	}

	public static func getValue(for key: Configuration.Keys, in environment: Environment) -> String? {
		guard
			let environmentInfo = _configuration[environment.key] as? [AnyHashable: Any],
			let value = environmentInfo[key.rawValue] as? String else {
				assertionFailure("Invalid credentials.plist file for key: \(key.rawValue)")
				return nil
		}

		return value
	}
}
