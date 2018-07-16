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
		case .posts			: return "Posts"
		case .countries		: return "Countries"
		case .videos		: return "Videos"
		}
	}

	var destination : DetailViewRooter.Destination {
		switch self {
		case .posts			: return .post
		case .countries		: return .country
		case .videos		: return .video
		}
	}

	var fetch: ((@escaping (([Any], Error?) -> Void)) -> Void)? {
		switch self {
		case .posts			: return PostManager.fetchEntities
		case .countries		: return CountryManager.fetchEntities
		case .videos		: return VideoManager.fetchEntities
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
