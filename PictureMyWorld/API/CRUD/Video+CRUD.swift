//
//  Video+CRUD.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

extension Video: CRUD {

	static var entityEndpoint: Endpoint {
		return .video
	}

	static var entitiesEndpoint: Endpoint {
		return .videos
	}
}
