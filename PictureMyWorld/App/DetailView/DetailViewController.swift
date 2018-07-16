//
//  DetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DetailViewController	: UIViewController {

	// MARK: - Private Attributes

	internal var entity		: Serializable?
	internal var responders	= [UIResponder]()

	// MARK: - Life View Cycles

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupUIElements()
	}

	func setupUIElements() {
		// Override in subclass to init all outlets.
	}

	func setup(with entity: Serializable? = nil) {
		self.entity = entity
	}
}

extension DetailViewController {

	@IBAction func save() {
		// TODO: API call
		self.navigationController?.popViewController(animated: true)
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
