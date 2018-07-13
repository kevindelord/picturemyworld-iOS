//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController					: UIViewController {

	@IBOutlet private weak var tableView		: ContentTableView?

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension DashboardViewController {

	@IBAction private func checkDesployedVersions() {
		// Fetch and display the deployed versions.
		VersionManager.presentDeployedVersion()
	}

	@IBAction private func reloadListView(_ sender: UIButton) {

		self.tableView?.load(for: .posts)
	}
}
