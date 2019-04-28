//
//  SettingsViewController.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import UIKit

class SettingsViewContoller : UICollectionViewController, SettingsDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Environments"
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Environment.allCases.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// get a reference to our storyboard cell
		guard
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Settings.ReuseIdentifier.environmentCell, for: indexPath) as? EnvironmentCollectionViewCell,
			let environment = Environment(rawValue: indexPath.item) else {
				fatalError("Cannot dequeue settings collection view cell.")
		}

		// Use the outlet in our custom class to get a reference to the UILabel in the cell
		cell.setup(for: environment, settingsDelegate: self)
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		guard
			let controller = segue.destination as? WebViewController,
			let environment = sender as? Environment else {
				return
		}

		controller.setup(environment: environment)
	}

	// MARK: - Version Management

	//	private func fetchDeployedVersion() {
	//		APIManager.fetchVersions(completion: { [weak self] (versions: [Environment: String], error: Error?) in
	//			if let error = error {
	//				UIAlertController.showErrorMessage(error.localizedDescription)
	//			} else {
	//				self?.deployedVersions = versions
	//				self?.displayEnvironmentVersion()
	//			}
	//		})
	//	}
}

// MARK: - Settings Delegate Methods

extension SettingsViewContoller {

	internal func previewWebsite(for environment: Environment?) {
		self.performSegue(withIdentifier: Settings.Segue.webPreview, sender: environment)
	}

	internal func deploy(to environment: Environment?) {
		print("TODO: use APIManager")
	}
}
