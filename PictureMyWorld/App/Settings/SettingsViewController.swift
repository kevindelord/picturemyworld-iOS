//
//  SettingsViewController.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import UIKit

class SettingsViewContoller 		: UICollectionViewController, SettingsDelegate {

	// MARK: - Private Attributes

	private var deployedVersions 	= [Environment: String]()
	private var refreshControl 		= UIRefreshControl()

	// MARK: - View life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Environments"

		// Setup Refresh Contol
		self.refreshControl.tintColor = self.view.tintColor
		self.refreshControl.addTarget(self, action: #selector(self.fetchDeployedVersion), for: .valueChanged)
		self.collectionView.alwaysBounceVertical = true
		self.collectionView.addSubview(self.refreshControl)

		// Fetch data and relaod table view
		self.fetchDeployedVersion()
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
}

// MARK: - Collection view

extension SettingsViewContoller {

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
		cell.setup(for: environment, settingsDelegate: self, version: self.deployedVersions[environment] ?? "")
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
	}
}

// MARK: - Version Management

extension SettingsViewContoller {

	@objc private func fetchDeployedVersion() {
		APIManager.fetchVersions(completion: { [weak self] (versions: [Environment: String], error: Error?) in
			if let error = error {
				UIAlertController.showErrorMessage(error.localizedDescription)
			} else {
				self?.deployedVersions = versions
				self?.collectionView.reloadData()
			}

			self?.refreshControl.endRefreshing()
		})
	}
}

// MARK: - Settings Delegate Methods

extension SettingsViewContoller {

	internal func previewWebsite(for environment: Environment?) {
		self.performSegue(withIdentifier: Settings.Segue.webPreview, sender: environment)
	}

	internal func deploy(to environment: Environment?) {
		guard let environment = environment else {
			return
		}

		APIManager.deployChanges(to: environment, completion: { [weak self] (error: Error?) in
			if let error = error {
				UIAlertController.showErrorMessage(error.localizedDescription)
			} else {
				// Refresh the deployed version and reload the collection view.
				self?.fetchDeployedVersion()
			}
		})
	}
}
