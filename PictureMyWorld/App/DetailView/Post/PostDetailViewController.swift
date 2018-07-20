//
//  PostDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class PostDetailViewController					: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var imageView		: UIImageView!
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
			self.imageView.backgroundColor = .clear
			return
		}

		self.titleTextField.text = post.title
		self.imageTextField.text = post.image
		self.dateTextField.text = post.date
		self.filenameTextField.text = post.filename
		self.locationTextField.text = post.locationText
		self.captionTextView.text = post.caption

		APIManager.downloadAndCache(.thumbnail, for: post.image, completion: { [weak self] (image: UIImage?) in
			self?.imageView.image = image
		})
	}

	override var serializedEntity				: [String: Any] {
		return [
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			//			API.JSON.image: self.imageFile, TODO: when creating a new post. Upload valid image file.
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.locationText: (self.locationTextField.text ?? "")
		]
	}
}


// MARK: - IBActions

extension PostDetailViewController {

	@IBAction private func selectPhotoFromLibrary() {

	}
}

