//
//  CountryDetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 14.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class PostDetailViewController				: DetailViewController {
}

class VideoDetailViewController				: DetailViewController {
}

class CountryDetailViewController				: DetailViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var nameTextField	: UITextField!
	@IBOutlet private weak var photoTextField	: UITextField!
	@IBOutlet private weak var filenameTextField: UITextField!
	@IBOutlet private weak var linkTextField	: UITextField!
	@IBOutlet private weak var ratioTextField	: UITextField!

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

extension CountryDetailViewController {

	@IBAction func saveCountry() {
		// TODO: API call
		self.navigationController?.popViewController(animated: true)
	}
}
