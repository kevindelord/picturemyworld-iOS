//
//  SettingsViewController.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import UIKit

// TODO: add constant file
// TODO: add documentation

protocol SettingsDelegate {

	func previewWebsite(for environment: Environment?)

	func deploy(to environment: Environment?)
}

class SettingsViewContoller : UICollectionViewController, SettingsDelegate {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Environment.allCases.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// get a reference to our storyboard cell
		guard
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnvironmentCell", for: indexPath) as? EnvironmentCollectionViewCell,
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

	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		// TODO: why is hasWebContent never correct for dev?
		guard
			let environment = sender as? Environment,
			(environment.hasWebContent == true) else {
				return false
		}

		return true
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
		self.performSegue(withIdentifier: "OpenWebViewer", sender: environment)
	}

	internal func deploy(to environment: Environment?) {
		print("TODO: use APIManager")
	}
}

class EnvironmentCollectionViewCell 			: UICollectionViewCell {

	@IBOutlet private weak var nameLabel 		: UILabel!
	@IBOutlet private weak var versionLabel		: UILabel!
	@IBOutlet private weak var websiteLabel 	: UILabel!
	@IBOutlet private weak var webPreviewButton : UIButton!
	@IBOutlet private weak var deployButton 	: UIButton!

	private var environment						: Environment?
	private var settingsDelegate				: SettingsDelegate?

	func setup(for environment: Environment?, settingsDelegate: SettingsDelegate) {
		self.settingsDelegate = settingsDelegate
		self.environment = environment
		self.nameLabel.text = self.environment?.key
		self.versionLabel.text = "Version: TODO"
		self.websiteLabel.text = self.environment?.webURL?.absoluteString
		self.webPreviewButton.isHidden = (self.environment?.hasWebContent == false)
		self.deployButton.isHidden = (self.environment?.hasWebContent == false)
	}
}

extension EnvironmentCollectionViewCell {

	@IBAction private func openPreviewWebsite() {
		self.settingsDelegate?.previewWebsite(for: self.environment)
	}

	@IBAction private func deployToEnvironment() {
		self.presentDeployAlert()
	}

	private func presentDeployAlert() {
		guard let env = self.environment?.key else {
			return
		}

		let alert = UIAlertController(title: nil, message: "Deploy changes to '\(env)' ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes, I'm sure", style: .destructive, handler: { [weak self] (_ : UIAlertAction) in
			self?.settingsDelegate?.deploy(to: self?.environment)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		AppDelegate.alertPresentingController?.present(alert, animated: true, completion: nil)
	}
}
