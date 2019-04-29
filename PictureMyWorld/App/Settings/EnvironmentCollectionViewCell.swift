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
	@IBOutlet private weak var webPreviewButton : UIButton!
	@IBOutlet private weak var deployButton 	: UIButton!

	private var environment						: Environment?
	private var settingsDelegate				: SettingsDelegate?

	func setup(for environment: Environment?, settingsDelegate: SettingsDelegate, version: String) {
		self.settingsDelegate = settingsDelegate
		self.environment = environment
		self.nameLabel.text = self.environment?.key
		self.versionLabel.text = version
		self.webPreviewButton.isHidden = (self.environment?.hasWebContent == false)
		self.webPreviewButton.setTitle(self.environment?.webURL?.absoluteString, for: .normal)
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

		let alert = UIAlertController(title: nil, message: String(format: "settings.alert.messsage".localized(), env), preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "settings.alert.ok".localized(), style: .destructive, handler: { [weak self] (_ : UIAlertAction) in
			self?.settingsDelegate?.deploy(to: self?.environment)
		}))
		alert.addAction(UIAlertAction(title: "settings.alert.cancel".localized(), style: .cancel, handler: nil))

		AppDelegate.alertPresentingController?.present(alert, animated: true, completion: nil)
	}
}
