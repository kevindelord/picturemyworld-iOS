//
//  VideoDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailViewController					: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var webView			: WKWebView!
	@IBOutlet private weak var titleTextField	: UITextField!
	@IBOutlet private weak var dateTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var musicTextField	: UITextField!
	@IBOutlet private weak var youtubeTextField	: UITextField!
	@IBOutlet private weak var captionTextView	: UITextView!

	// MARK: - Setup functions

	override func setupUIElements() {
		super.setupUIElements()

		guard let video = self.entity as? Video else {
			return
		}

		self.titleTextField.text = video.title
		self.dateTextField.text = video.date
		self.filenameTextField.text = video.filename
		self.musicTextField.text = video.music
		self.youtubeTextField.text = video.youtubeIdentifier
		self.captionTextView.text = video.caption

		guard
			(video.youtubeIdentifier.isEmpty == false),
			let youtubeURL = URL(string: DetailViewConstants.youtubeBaseURL + video.youtubeIdentifier) else {
				return
		}

		self.webView.load(URLRequest(url: youtubeURL))
	}

	override var serializedEntity				: [String: Any] {
		return [
			// Parameters used ot identify the action type (create or update)
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			// Required Parameters
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.music: (self.musicTextField.text ?? ""),
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.youtubeIdentifier: (self.youtubeTextField.text ?? "")
		]
	}
}
