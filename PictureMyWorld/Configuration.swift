//
//  Configuration.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

private struct Configuration {

	static let _configuration = Configuration.setup()

	static func setup() -> NSDictionary {
		var configuration: NSDictionary?
		if let path = Bundle.main.path(forResource: "credentials", ofType: "plist") {
			configuration = NSDictionary(contentsOfFile: path)
		}

		return (configuration ?? NSDictionary())
	}

	fileprivate enum Keys	: String {
		case baseURL 		= "base_url"
		case webURL 		= "web_url"
		case username 		= "username"
		case password 		= "password"
	}

	fileprivate static func getValue(for key: Configuration.Keys, in environment: Environment) -> String? {
		guard
			let environmentInfo = _configuration[environment.key] as? [AnyHashable: Any],
			let value = environmentInfo[key.rawValue] as? String else {
				assertionFailure("Invalid credentials.plist file for key: \(key.rawValue)")
				return nil
		}

		return value
	}
}

enum Environment : Int {
	case development = 0
	case staging
	case producation

	fileprivate var key: String {
		switch self {
		case .development:	return "development"
		case .staging:		return "staging"
		case .producation:	return "production"
		}
	}

	static var current : Environment {
		return .development
	}

	var webURL: URL? {
		guard let webURLString = Configuration.getValue(for: .webURL, in: self) else {
			return nil
		}

		return URL(string: webURLString)
	}

	var hasWebContent: Bool {
		return (self.webURL != nil)
	}

	var baseURL: URL? {
		guard let baseURLString = Configuration.getValue(for: .baseURL, in: self) else {
			return nil
		}

		return URL(string: baseURLString)
	}

	var username: String? {
		return Configuration.getValue(for: .username, in: self)
	}

	var password: String? {
		return Configuration.getValue(for: .password, in: self)
	}
}
