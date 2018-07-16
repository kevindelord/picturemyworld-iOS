//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

protocol DashboardDelegate {

	func presentDetailView(for data: [AnyHashable: Any])
}

class DashboardViewController					: UIViewController {

	@IBOutlet private weak var segmentedControl	: ContentTypeSegmentedControl?
	@IBOutlet private weak var tableView		: ContentTableView?

	private var detailViewRooter				: DetailViewRooter?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.detailViewRooter = DetailViewRooter(navigationController: self.navigationController)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Reload the content to display in case it changed in a child view controller.
		self.reloadListView()
	}
}

extension DashboardViewController {

	@IBAction private func createNew() {
		let alertController = UIAlertController(title: "Create new...", message: nil, preferredStyle: .actionSheet)
		for destination in DetailViewRooter.Destination.allCases {
			alertController.addAction(UIAlertAction(title: destination.title, style: .default, handler: { (action: UIAlertAction) in
				self.detailViewRooter?.present(destination: destination, entity: nil)
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

		self.tableView?.load(for: type, rooter: self.detailViewRooter)
	}
}
