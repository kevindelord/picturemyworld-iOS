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
	private let isDebug     = true
	private let isRelease   = false
#else
	private let isDebug     = false
	private let isRelease   = true
#endif

struct Configuration {

	static let RestoreDatabaseOnStart		= (false && isDebug)
	static let DebugAppirater				= (false && isDebug)
	static let AnalyticsEnabled				= (true && isRelease)
}

// MARK: - Verbose

struct Verbose {

	struct Manager {

		static let Database					= false
		static let Asset 					= false
		static let Cache					= false
		static let HTMLParser				= false
		static let Analytics				= false
	}

	struct Database {

		static let Post          			= false
	}
}
