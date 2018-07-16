//
//  CountryDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 14.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class PostDetailViewController					: DetailViewController {

	// MARK: - IBOutlets


	@IBOutlet private weak var titleTextField	: UITextField!
	@IBOutlet private weak var imageTextField	: UITextField!
	@IBOutlet private weak var dateTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var locationTextField: UITextField!
	@IBOutlet private weak var captionTextView	: UITextView!

	// MARK: - Setup functions

	override func setupUIElements() {
		super.setupUIElements()

		guard let post = self.entity as? Post else {
			self.title = "Create new post"
			return
		}

		self.title = "Update post"
		self.titleTextField.text = post.title
		self.imageTextField.text = post.photo
		self.dateTextField.text = post.date
		self.filenameTextField.text = post.filename
		self.locationTextField.text = post.locationText
		self.captionTextView.text = post.caption
	}
}

class VideoDetailViewController					: DetailViewController {

	// MARK: - IBOutlets

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
			self.title = "Create new video"
			return
		}

		self.title = "Update video"
		self.titleTextField.text = video.title
		self.dateTextField.text = video.date
		self.filenameTextField.text = video.filename
		self.musicTextField.text = video.music
		self.youtubeTextField.text = video.youtubeIdentifier
		self.captionTextView.text = video.caption
	}
}

class CountryDetailViewController				: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var nameTextField	: UITextField!
	@IBOutlet private weak var photoTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var linkTextField	: UITextField!
	@IBOutlet private weak var ratioTextField	: UITextField!

	// MARK: - Setup functions

	override func setupUIElements() {
		super.setupUIElements()

		guard let country = self.entity as? Country else {
			self.title = "Create new country"
			return
		}

		self.title = "Update country"
		self.nameTextField.text = country.name
		self.photoTextField.text = country.photo
		self.filenameTextField.text = country.filename
		self.linkTextField.text = country.link
		self.ratioTextField.text = country.ratio
	}
}
