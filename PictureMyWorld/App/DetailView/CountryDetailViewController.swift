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

	override func setup(with entity: Serializable?) {
		super.setup(with: entity)

		self.contentType = .posts
	}

	override func setupUIElements() {
		super.setupUIElements()

		guard let post = self.entity as? Post else {
			self.title = "Create new post"
			return
		}

		self.title = "Update post"
		self.titleTextField.text = post.title
		self.imageTextField.text = post.image
		self.dateTextField.text = post.date
		self.filenameTextField.text = post.filename
		self.locationTextField.text = post.locationText
		self.captionTextView.text = post.caption
	}

	override var serializedEntity				: [String: Any] {
		return [
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.filename: (self.filenameTextField.text ?? ""),
//			API.JSON.image: self.imageFile, TODO
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.locationText: (self.locationTextField.text ?? "")
		]
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

	override func setup(with entity: Serializable?) {
		super.setup(with: entity)

		self.contentType = .videos
	}

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

	override var serializedEntity				: [String: Any] {
		return [
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			API.JSON.music: (self.musicTextField.text ?? ""),
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.youtubeIdentifier: (self.youtubeTextField.text ?? "")
		]
	}
}

class CountryDetailViewController				: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var nameTextField	: UITextField!
	@IBOutlet private weak var imageTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var linkTextField	: UITextField!
	@IBOutlet private weak var ratioTextField	: UITextField!

	// MARK: - Setup functions

	override func setup(with entity: Serializable?) {
		super.setup(with: entity)

		self.contentType = .countries
	}

	override func setupUIElements() {
		super.setupUIElements()

		guard let country = self.entity as? Country else {
			self.title = "Create new country"
			return
		}

		self.title = "Update country"
		self.nameTextField.text = country.name
		self.imageTextField.text = country.image
		self.filenameTextField.text = country.filename
		self.linkTextField.text = country.link
		self.ratioTextField.text = country.ratio
	}

	override var serializedEntity				: [String: Any] {
		return [
			API.JSON.name: (self.nameTextField.text ?? ""),
			API.JSON.image: (self.imageTextField.text ?? ""),
			API.JSON.filename: (self.filenameTextField.text ?? ""),
		]
	}
}
