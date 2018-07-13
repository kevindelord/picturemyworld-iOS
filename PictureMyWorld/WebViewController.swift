//
//  WebViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import WebKit

class WebViewController								: UIViewController, WKUIDelegate {

	private var webView								: WKWebView?
	@IBOutlet private weak var segmentedControl 	: UISegmentedControl!

	override func loadView() {
		let webConfiguration = WKWebViewConfiguration()
		self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
		webView?.uiDelegate = self
		self.view = webView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Load the default selected index from the storyboard.
		self.segmentedControlValueDidChange()
	}
}

// MARK: - Web Content management

extension WebViewController {

	private func clearWebContent() {
		guard let url = URL(string:"about:blank") else {
			return
		}

		self.webView?.load(URLRequest(url: url))
	}

	private func loadWebContent(for environment: Environment) {
		guard let url = environment.webURL else {
			return
		}

		self.webView?.load(URLRequest(url: url))
	}
}

// MARK: - User Action

extension WebViewController {

	@IBAction func segmentedControlValueDidChange() {
		let index = self.segmentedControl.selectedSegmentIndex
		guard
			let environment = Environment(rawValue: index),
			(environment.hasWebContent == true) else {
				return
		}

		self.loadWebContent(for: environment)
	}
}
