//
//  WebViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class WebViewController					: UIViewController {

	// MARK: - Private Attributes

	private var environment				= Environment.current

	// MARK: - Interface Builder Outlets

	@IBOutlet private weak var webView	: ContentWebView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = self.environment.key
		if (self.environment.hasWebContent == true) {
			self.webView.load(for: self.environment)
		}
	}

	func setup(environment: Environment) {
		self.environment = environment
	}
}
