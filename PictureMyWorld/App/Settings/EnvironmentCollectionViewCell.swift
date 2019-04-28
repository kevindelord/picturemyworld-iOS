//
//  EnvironmentCollectionViewCell.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import UIKit

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
