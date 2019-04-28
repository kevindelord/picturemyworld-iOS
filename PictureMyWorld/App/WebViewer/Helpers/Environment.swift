//
//  Environment.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

enum Environment : Int {
	case development = 0
	case staging
	case producation

	var key: String {
		switch self {
		case .development:	return Configuration.SupportedEnvironmentName.development.rawValue
		case .staging:		return Configuration.SupportedEnvironmentName.staging.rawValue
		case .producation:	return Configuration.SupportedEnvironmentName.producation.rawValue
		}
	}

	static var current : Environment {
		#if targetEnvironment(simulator)
			// Default environment for local development.
			return .development
		#else
			// Default environment for active usage (ie. on a device).
			return .staging
		#endif
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
