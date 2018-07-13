//
//  WebViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import WebKit

enum WebIndex : Int {
	case staging = 0
	case producation

	var url: URL? {
		switch self {
		case .staging:		return URL(string: "https://kevindelord.io/staging")
		case .producation:	return URL(string: "http://picturemy.world")
		}
	}
}

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

		self.segmentedControlValueDidChange()
	}

	@IBAction func segmentedControlValueDidChange() {
		guard
			let web = WebIndex(rawValue: self.segmentedControl.selectedSegmentIndex),
			let url = web.url else {
				return
		}

		self.webView?.load(URLRequest(url: url))
	}
}
