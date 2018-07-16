//
//  Model.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

protocol Model {

	init(json: [AnyHashable: Any])

	var isInvalid: Bool { get }
}
