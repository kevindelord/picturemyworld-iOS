//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController					: UIViewController, DashboardDelegate, ProgressView {

	@IBOutlet private weak var segmentedControl	: ContentTypeSegmentedControl?
	@IBOutlet private weak var tableView		: ContentTableView?

	// MARK: - Private Attributes

	internal var progressView					: LinearProgressView?
	private var detailViewRooter				: DetailViewRooter?
	private var contentManager 					= ContentManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "dashboard.title".localized()
		self.detailViewRooter = DetailViewRooter(navigationController: self.navigationController)
		self.tableView?.setup(with: self.contentManager, contentDelegate: self.contentManager, dashboardDelegate: self)
	}
}

extension DashboardViewController {

	@IBAction private func createNew() {
		let alertController = UIAlertController(title: "dashboard.alert.create.message".localized(), message: nil, preferredStyle: .actionSheet)
		for destination in DetailViewRooter.Destination.allCases {
			alertController.addAction(UIAlertAction(title: destination.title, style: .default, handler: { [weak self] (action: UIAlertAction) in
				self?.present(destination: destination, entity: nil)
			}))
		}

		alertController.addAction(UIAlertAction(title: "dashboard.alert.create.cancel".localized(), style: .cancel, handler: nil))
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
		self.reloadTableView()
	}
}

extension DashboardViewController {

	func present(destination: DetailViewRooter.Destination, entity: Model?) {
		self.detailViewRooter?.present(destination: destination, entity: entity, contentDataSource: self.contentManager, dashboardDelegate: self)
	}

	/// Reload the table view with the correct data type.
	func reloadTableView() {
		self.tableView?.reloadContent(deleteRows: [])
	}

	var loadingContainer : (view: UIView, anchor: NSLayoutYAxisAnchor)  {
		return (view: self.view, anchor: self.view.safeAreaLayoutGuide.topAnchor)
	}
}
