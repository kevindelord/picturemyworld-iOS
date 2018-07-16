//
//  Country+CRUD.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

extension Country: CRUD {

	static var entityEndpoint: Endpoint {
		return .country
	}

	static var entitiesEndpoint: Endpoint {
		return .countries
	}
}
