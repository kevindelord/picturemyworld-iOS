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

	enum Destination {
		case post
		case country
		case video

		private var identifier: String {
			switch self {
			case .post:		return "\(PostDetailViewController.self)"
			case .country:	return "\(CountryDetailViewController.self)"
			case .video:	return "\(VideoDetailViewController.self)"
			}
		}

		private var storyboard: UIStoryboard {
			return UIStoryboard(name: "DetailView", bundle: nil)
		}

		var instantiateViewController: DetailViewController? {
			let controller = self.storyboard.instantiateViewController(withIdentifier: self.identifier)
			return (controller as? DetailViewController)
		}
	}

	func present(destination: Destination, entity: Serializable) {
		guard let controller = destination.instantiateViewController else {
			fatalError("Cannot instantiate detail view controller.")
		}

		controller.setup(with: entity)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
