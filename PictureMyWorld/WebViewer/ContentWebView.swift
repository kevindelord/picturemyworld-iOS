//
//  ContentWebView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import WebKit

class ContentWebView : WKWebView {

	init() {
		let webConfiguration = WKWebViewConfiguration()
		super.init(frame: .zero, configuration: webConfiguration)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func clearWebContent() {
		guard let url = URL(string:"about:blank") else {
			return
		}

		self.load(URLRequest(url: url))
	}

	public func load(for environment: Environment) {
		guard
			(environment.hasWebContent == true),
			let url = environment.webURL else {
				self.clearWebContent()
				return
		}

		self.load(URLRequest(url: url))
	}
}
