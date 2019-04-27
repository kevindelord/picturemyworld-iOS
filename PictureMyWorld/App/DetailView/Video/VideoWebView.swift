//
//  VideoWebView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import WebKit

class VideoWebView : WKWebView {

	private func html(forYoutubeIdentifier identifier: String) -> String {
		let width = Int(self.frame.size.width)
		let height = Int(self.frame.size.height)
		let src = "https://www.youtube.com/embed/\(identifier)"
		let html = "<iframe width=\"\(width)\" height=\"\(height)\" src=\"\(src)\" frameborder=\"0\" allowfullscreen></iframe>"
		return html
	}

	public func load(videoForYoutubeIdentifier identifier: String) {
		guard (identifier.isEmpty == false) else {
			return
		}

		let html = self.html(forYoutubeIdentifier: identifier)
		print(html)
		self.loadHTMLString(html, baseURL: nil)
	}
}
