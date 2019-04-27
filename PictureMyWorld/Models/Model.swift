//
//  Model.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

protocol Model {

	// MARK: - Initialization Methods

	init(json		: [AnyHashable: Any])

	// MARK: - Helper functions

	var isInvalid	: Bool { get }

	// MARK: - Common Properties

	var title		: String { get set }
	var filename	: String { get set }
}
