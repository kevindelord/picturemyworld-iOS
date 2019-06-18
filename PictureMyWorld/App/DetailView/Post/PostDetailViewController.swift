//
//  PostDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import CoreLocation

class PostDetailViewController					: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var imageView		: UIImageView!
	@IBOutlet private weak var titleTextField	: UITextField!
	@IBOutlet private weak var imageTextField	: UITextField!
	@IBOutlet private weak var dateTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var locationTextField: UITextField!
	@IBOutlet private weak var countryTextField	: UITextField!
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
		self.countryTextField.text = post.country

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
		var location = (self.locationTextField.text ?? "")
		let country = (self.countryTextField.text ?? "")
		location = (location.isEmpty == true ? country : location + ", " + country)

		return [
			// Parameters used ot identify the action type (create or update)
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			// Required Parameters
			API.JSON.date: (self.dateTextField.text ?? ""),
			API.JSON.caption: (self.captionTextView.text ?? ""),
			API.JSON.title: (self.titleTextField.text ?? ""),
			API.JSON.location: location
			// API.JSON.image: The image is sent as a raw data by the APImanager.
		]
	}
}

// MARK: - IBActions

extension PostDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	private func process(image: UIImage?, date: Date?, location: CLLocation?) {
		self.showProgressView()
		self.imageView.image = image
		self.dateTextField?.text = DetailViewConstants.dateFormat.using(date: date)

		// Clear the cached image. Next time the new picture (with the same name) will be downloaded again.
		if let imageName = (self.entity as? Post)?.image {
			APIManager.clearCache(image: imageName)
		}

		// If any location, reverse the geocode to determine the area of interest.
		AssetLocation.reverse(location: location, completionHandler: { (location: String?, country: String?) in
			self.locationTextField?.text = location
			self.countryTextField?.text = country
			self.hideProgressView()
		})
	}

	@IBAction private func selectPhotoFromLibrary() {
		let imagePicker = ImagePicker { [weak self] (image: UIImage?, date: Date?, location: CLLocation?) in
			self?.presentedViewController?.dismiss(animated: true, completion: {
				self?.process(image: image, date: date, location: location)
			})
		}

		self.present(imagePicker, animated: true, completion: nil)
	}

	@IBAction private func copyImageNameToClipboard() {
		UIPasteboard.general.string = self.imageTextField.text
	}
}

extension String {

	fileprivate func using(date: Date?) -> String? {
		guard let date = date else {
			return nil
		}

		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = self
		return dateFormatterGet.string(from: date)
	}
}
