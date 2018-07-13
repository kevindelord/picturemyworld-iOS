//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController					: UIViewController {

	@IBOutlet private weak var versionsLabel	: UILabel?

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Fetch and display the deployed versions.
		VersionManager.fetch(completion: self.displayDeployedVersion)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

	}

	private func displayDeployedVersion(versions: [Environment: String], error: Error?) {
		if let error = error {
			UIAlertController.showErrorMessage(error.localizedDescription,
											   presentingViewController: AppDelegate.alertPresentingController)
		}

		let environments = versions.keys.sorted { (lhs: Environment, rhs: Environment) -> Bool in
			return (lhs.rawValue < rhs.rawValue)
		}

		var versionString = ""
		for environment in environments {
			versionString += "\(environment.key): \(versions[environment] ?? "")\n\n"
		}

		// Remove last 2 "\n"
		versionString.removeLast(2)

		self.versionsLabel?.text = versionString
	}
}

extension DashboardViewController {

	@IBAction private func openListView(_ sender: UIButton) {
		self.performSegue(withIdentifier: "openListView", sender: sender)
	}
}
