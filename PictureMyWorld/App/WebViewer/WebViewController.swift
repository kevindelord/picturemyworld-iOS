//
//  WebViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class WebViewController								: UIViewController {

	// MARK: - Private Attributes

	private var deployedVersions					= [Environment: String]()

	// MARK: - Interface Builder Outlets

	@IBOutlet private weak var segmentedControl 	: EnvironmentSegmentedControl?
	@IBOutlet private var webView					: ContentWebView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Load the default selected index from the storyboard.
		self.reloadWebContent()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.fetchDeployedVersion()
	}
}

// MARK: - Computed Properties

extension WebViewController {

	private var selectedEnvironment: Environment {
		guard
			let index = self.segmentedControl?.selectedSegmentIndex,
			let environment = Environment(rawValue: index) else {
				return Environment.current
		}

		return environment
	}

	private var selectEnvironmentVersion: String {
		let version = self.deployedVersions[self.selectedEnvironment]
		return (version ?? "")
	}
}

// MARK: - Version Management

extension WebViewController {

	private func displayEnvironmentVersion() {
		self.title = self.selectEnvironmentVersion
	}

	private func fetchDeployedVersion() {
		APIManager.fetchVersions(completion: { [weak self] (versions: [Environment: String], error: Error?) in
			if let error = error {
				UIAlertController.showErrorMessage(error.localizedDescription)
			} else {
				self?.deployedVersions = versions
				self?.displayEnvironmentVersion()
			}
		})
	}
}

// MARK: - User Action

extension WebViewController {

	@IBAction private func reloadWebContent() {
		self.webView.load(for: self.selectedEnvironment)
		self.displayEnvironmentVersion()
	}
}
