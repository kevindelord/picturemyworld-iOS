//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController					: UIViewController, DashboardDelegate {

	@IBOutlet private weak var segmentedControl	: ContentTypeSegmentedControl?
	@IBOutlet private weak var tableView		: ContentTableView?

	private var detailViewRooter				: DetailViewRooter?
	private var contentManager 					= ContentManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.detailViewRooter = DetailViewRooter(navigationController: self.navigationController)
		self.tableView?.setup(with: self.contentManager, contentDelegate: self.contentManager, dashboardDelegate: self)
	}
}

extension DashboardViewController {

	@IBAction private func createNew() {
		let alertController = UIAlertController(title: "Create new...", message: nil, preferredStyle: .actionSheet)
		for destination in DetailViewRooter.Destination.allCases {
			alertController.addAction(UIAlertAction(title: destination.title, style: .default, handler: { (action: UIAlertAction) in
				self.detailViewRooter?.present(destination: destination, entity: nil, contentDelegate: self.contentManager)
			}))
		}

		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}

	@IBAction private func reloadListView() {
		guard
			let index = self.segmentedControl?.selectedSegmentIndex,
			let type = ContentType(rawValue: index) else {
				return
		}

		// Update the current content type
		self.contentManager.contentType = type
		// Reload the table view with the correct data type.
		self.tableView?.reloadContent(deleteRows: [])
	}
}

extension DashboardViewController {

	func present(destination: DetailViewRooter.Destination, entity: Model?) {
		self.detailViewRooter?.present(destination: destination, entity: entity, contentDelegate: self.contentManager)
	}
}
