//
//  DetailViewRooter.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

struct DetailViewRooter {

	private weak var navigationController: UINavigationController?

	init(navigationController: UINavigationController?) {
		self.navigationController = navigationController
	}

	enum Destination	: Int {
		case post 		= 0
		case country
		case video

		var contentType: ContentType {
			switch self {
			case .post:		return .posts
			case .country:	return .countries
			case .video:	return .videos
			}
		}

		var title: String {
			switch self {
			case .post:		return "detail.title.post".localized()
			case .country:	return "detail.title.country".localized()
			case .video:	return "detail.title.video".localized()
			}
		}

		private var identifier: String {
			switch self {
			case .post:		return "\(PostDetailViewController.self)"
			case .country:	return "\(CountryDetailViewController.self)"
			case .video:	return "\(VideoDetailViewController.self)"
			}
		}

		private var storyboard: UIStoryboard {
			return UIStoryboard(name: DetailViewConstants.storyboardName, bundle: nil)
		}

		var instantiateViewController: DetailViewController? {
			let controller = self.storyboard.instantiateViewController(withIdentifier: self.identifier)
			return (controller as? DetailViewController)
		}
	}

	func present(destination: Destination, entity: Model?, contentDataSource: ContentManagerDataSource, dashboardDelegate: DashboardDelegate?) {
		guard let controller = destination.instantiateViewController else {
			fatalError("Cannot instantiate detail view controller.")
		}

		controller.setup(with: entity, contentDataSource: contentDataSource, dashboardDelegate: dashboardDelegate)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
