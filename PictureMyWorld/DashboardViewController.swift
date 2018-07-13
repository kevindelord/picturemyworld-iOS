//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController					: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

//		PostManager.fetchEntities { (posts: [Post], error: Error?) in
//			print(posts.count)
//			if let error = error {
//				UIAlertController.showErrorMessage(error.localizedDescription,
//												   presentingViewController: AppDelegate.alertPresentingController)
//			}
//		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

	}
}

extension DashboardViewController {

	@IBAction private func checkDesployedVersions() {
		// Fetch and display the deployed versions.
		VersionManager.presentDeployedVersion()
	}

	@IBAction private func openListView(_ sender: UIButton) {
	}
}
