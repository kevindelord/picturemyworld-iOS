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

		APIManager.downloadAndCache(image: post.image, completion: { [weak self] (image: UIImage?) in
			self?.imageView.image = image
		})
	}

	override internal var imageData : Data? {
		// If needed, override in subclass to upload an image.
		guard
			let image = self.imageView.image,
			let jpegRepresentation = image.jpegData(compressionQuality: 1.0) else {
				return nil
		}

		return jpegRepresentation
	}

	override var serializedEntity				: [String: Any] {
		return [
			// Parameters used ot identify the action type (create or update)
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			// Required Parameters
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.location: (self.locationTextField.text ?? "")
			// API.JSON.image: The image is sent as a raw data by the APImanager.
		]
	}
}

// MARK: - IBActions

extension PostDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBAction private func selectPhotoFromLibrary() {
		let imagePicker = ImagePicker { [weak self] (image: UIImage?) in
			self?.imageView.image = image

			// Clear the cached image. Next time the new picture (with the same name) will be downloaded again.
			if let imageName = (self?.entity as? Post)?.image {
				APIManager.clearCache(image: imageName)
			}
		}

		self.present(imagePicker, animated: true, completion: nil)
	}

	@IBAction private func copyImageNameToClipboard() {
		UIPasteboard.general.string = self.imageTextField.text
	}
}
