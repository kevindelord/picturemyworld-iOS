//
//  PostDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

// TODO: use reachability to prevent API calls when there is no internet.
// TODO: Integrate scroll view.

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

	override internal var imageData : Data? {
		// If needed, override in subclass to upload an image.
		guard
			let image = self.imageView.image,
			let jpegRepresentation = UIImageJPEGRepresentation(image, 1.0) else {
				return nil
		}

		return jpegRepresentation
	}

	override var serializedEntity				: [String: Any] {
		return [
			// TODO: Use real value from the text fields.
			API.JSON.caption: "tmp caption",//(self.captionTextView.text ?? ""),
			API.JSON.date: "2018-07-07",//(self.dateTextField.text ?? ""),
//			API.JSON.filename: (self.filenameTextField.text ?? ""),
			API.JSON.title: "Tmp Tile Awesome",//(self.titleTextField.text ?? ""),
			API.JSON.location: "testing upload"//(self.locationTextField.text ?? "")
		]
	}
}


// MARK: - IBActions

extension PostDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBAction private func selectPhotoFromLibrary() {
		let imagePicker = ImagePicker { [weak self] (image: UIImage?) in
			self?.imageView.image = image
		}

		self.present(imagePicker, animated: true, completion: nil)
	}
}
