//
//  DetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DetailViewController			: UIViewController {

	// MARK: - Outlets

	@IBOutlet private weak var scrollView: DetailScrollView!

	// MARK: - Private Attributes

	internal var entity				: Model?
	internal var contentType		: ContentType?
	private var contentDelegate		: ContentManagerDelegate?

	// MARK: - Computed Properties

	internal var serializedEntity	: [String: Any] {
		// Override in subclass.
		fatalError("Must be overridden in subclass")
	}

	internal var imageData			: Data? {
		// If needed, override in subclass to upload an image.
		return nil
	}

	// MARK: - Life View Cycles

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = self.contentType?.destination.title
		self.setupUIElements()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.registerNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.unregisterNotifications()
	}

	// MARK: - Setup Functions

	func setupUIElements() {
		// Override in subclass to init all outlets.
	}

	func setup(with contentType: ContentType, entity: Model?, contentDelegate: ContentManagerDelegate?) {
		self.contentType = contentType
		self.entity = entity
		self.contentDelegate = contentDelegate
	}
}

extension DetailViewController {

	private func registerNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func unregisterNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillShow(notification: NSNotification){
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}

		self.scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
	}

	@objc func keyboardWillHide(notification: NSNotification) {
		self.scrollView.contentInset.bottom = 0
	}
}

extension DetailViewController {

	@IBAction func save() {
		self.contentType?.createOrUpdateEntity(self.serializedEntity, self.imageData) { [weak self] (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			// Reload the displayed content in the main table view.
			self?.contentDelegate?.reloadContent(deleteRows: [])
			self?.navigationController?.popViewController(animated: true)
		}
	}
}
