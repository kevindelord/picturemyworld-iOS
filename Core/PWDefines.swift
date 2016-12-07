//
//  PWDefines.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 06/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation

// MARK: - Configuration

#if DEBUG
	private let isDebug = true
#else
	private let isDebug = false
#endif

struct Configuration {

	static let RestoreDatabaseOnStart		= (false && isDebug)
}

// MARK: - Verbose

struct Verbose {

	struct Manager {

		static let Database					= false
		static let Asset 					= false
		static let Cache					= false
		static let HTMLParser				= true
	}

	struct Database {

		static let Post          			= false
	}
}
