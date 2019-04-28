//
//  CountryDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 14.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class CountryDetailViewController				: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var imageView		: UIImageView!
	@IBOutlet private weak var nameTextField	: UITextField!
	@IBOutlet private weak var imageTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var linkTextField	: UITextField!
	@IBOutlet private weak var ratioTextField	: UITextField!

	// MARK: - Setup functions

	override func setupUIElements() {
		super.setupUIElements()

		guard let country = self.entity as? Country else {
			return
		}

		self.nameTextField.text = country.title
		self.imageTextField.text = country.image
		self.filenameTextField.text = country.filename
		self.linkTextField.text = country.link
		self.ratioTextField.text = country.ratio

		APIManager.downloadAndCache(image: country.image, completion: { [weak self] (image: UIImage?) in
			self?.imageView.image = image
		})
	}

	override var serializedEntity				: [String: Any] {
		return [
			// Parameters used ot identify the action type (create or update)
			API.JSON.filename: (self.filenameTextField.text ?? ""),
			// Required Parameters
			API.JSON.name: (self.nameTextField.text ?? ""),
			API.JSON.image: (self.imageTextField.text ?? "")
		]
	}
}
