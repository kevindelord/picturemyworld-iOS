//
//  ContentType.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

enum ContentType : Int {
	case posts = 0
	case countries
	case videos

	static var defaultType : ContentType = .posts

	static var defaultData : [ContentType: [Any]] {
		var contentData	= [ContentType: [Any]]()
		for type in ContentType.allCases {
			contentData[type] = []
		}

		return contentData
	}

	var title: String {
		switch self {
		case .posts			: return "content.posts".localized()
		case .countries		: return "content.countries".localized()
		case .videos		: return "content.videos".localized()
		}
	}

	var sorting: ((Any, Any) -> Bool) {
		switch self {
		case .posts			: return { ((($0 as? Post)?.date ?? "") > (($1 as? Post)?.date ?? "")) }
		case .countries		: return { ((($0 as? Country)?.link ?? "") < (($1 as? Country)?.link ?? "")) }
		case .videos		: return { ((($0 as? Video)?.date ?? "") > (($1 as? Video)?.date ?? "")) }
		}
	}

	var destination : DetailViewRooter.Destination {
		switch self {
		case .posts			: return .post
		case .countries		: return .country
		case .videos		: return .video
		}
	}

	var reuseIdentifier: String {
		switch self {
		case .posts			: return "post_list_cell_view"
		case .countries		: return "country_list_cell_view"
		case .videos		: return "video_list_cell_view"
		}
	}

	func update(cell: UITableViewCell, with data: Any?) {
		switch self {
		case .posts			: (cell as? PostTableViewCell)?.update(with: data as? Post)
		case .countries		: (cell as? CountryTableViewCell)?.update(with: data as? Country)
		case .videos		: (cell as? VideoTableViewCell)?.update(with: data as? Video)
		}
	}

	var heightForRow: CGFloat {
		switch self {
		case .posts			: return 98.0
		case .countries		: return 73.0
		case .videos		: return 98.0
		}
	}
}

// MARK: -  CRUD Extension

extension ContentType {

	var fetchEntities: (@escaping (([Any], Error?) -> Void)) -> Void {
		switch self {
		case .posts			: return Post.fetchEntities
		case .countries		: return Country.fetchEntities
		case .videos		: return Video.fetchEntities
		}
	}

	var createOrUpdateEntity: ([String: Any], Data?, @escaping (Error?) -> Void) -> Void {
		switch self {
		case .posts			: return Post.createOrUpdateEntity
		case .countries		: return Country.createOrUpdateEntity
		case .videos		: return Video.createOrUpdateEntity
		}
	}

	var deleteEntity: (String, @escaping (Error?) -> Void) -> Void {
		switch self {
		case .posts			: return Post.deleteEntity
		case .countries		: return Country.deleteEntity
		case .videos		: return Video.deleteEntity
		}
	}
}
