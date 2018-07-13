//
//  WebViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class WebViewController								: UIViewController {

	private var webView								= ContentWebView()
	@IBOutlet private weak var segmentedControl 	: EnvironmentSegmentedControl?

	override func loadView() {
		self.view = self.webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Load the default selected index from the storyboard.
		self.reloadWebContent()
	}
}

// MARK: - User Action

extension WebViewController {

	@IBAction func reloadWebContent() {
		guard
			let index = self.segmentedControl?.selectedSegmentIndex,
			let environment = Environment(rawValue: index) else {
				return
		}

		self.webView.load(for: environment)
	}
}
