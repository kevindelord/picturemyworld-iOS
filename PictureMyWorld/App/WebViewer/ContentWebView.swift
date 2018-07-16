//
//  ContentWebView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import WebKit

class ContentWebView : WKWebView {

	private func clearWebContent() {
		guard let url = URL(string:"about:blank") else {
			return
		}

		self.load(URLRequest(url: url))
	}

	public func load(for environment: Environment) {
		self.clearWebContent()

		guard
			(environment.hasWebContent == true),
			let url = environment.webURL else {
				return
		}

		self.load(URLRequest(url: url))
	}
}
