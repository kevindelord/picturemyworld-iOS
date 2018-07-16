//
//  DetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DetailViewController			: UIViewController {

	// MARK: - Private Attributes

	internal var entity				: Model?
	internal var contentType		: ContentType?

	// MARK: - Computed Properties

	internal var serializedEntity	: [String: Any] {
		// Override in subclass.
		fatalError("Must be overridden in subclass")
	}

	// MARK: - Life View Cycles

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupUIElements()
	}

	// MARK: - Setup Functions

	func setupUIElements() {
		// Override in subclass to init all outlets.
	}

	func setup(with entity: Model? = nil) {
		self.entity = entity
	}
}

extension DetailViewController {

	@IBAction func save() {
		self.contentType?.createOrUpdateEntity(self.serializedEntity) { [weak self] (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			self?.navigationController?.popViewController(animated: true)
		}
	}
}

extension DetailViewController {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
}

//extension DetailViewController: UITextFieldDelegate {
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		TODO
//	}
//}
