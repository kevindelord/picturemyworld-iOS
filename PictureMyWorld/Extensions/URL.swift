//
//  URL.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 SMF. All rights reserved.
//

import Foundation

extension URL {

	func add(path component: String) -> URL? {
		return self.appendingPathComponent(component)
	}

	func add(parameters parameterArray: [String: String]) -> URL? {
		guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			return nil
		}

		var queryItems = (urlComponents.queryItems ?? [URLQueryItem]())

		for (key, value) in parameterArray {
			queryItems.append(URLQueryItem(name: key, value: value))
		}

		urlComponents.queryItems = queryItems

		return urlComponents.url
	}
}
