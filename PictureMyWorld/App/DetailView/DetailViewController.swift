//
//  DetailViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DetailViewController			: UIViewController, ProgressView {

	// MARK: - Outlets

	@IBOutlet private weak var scrollView: DetailScrollView!

	// MARK: - Private Attributes

	internal var entity				: Model?
	private var contentDataSource	: ContentManagerDataSource?
	private var dashboardDelegate	: DashboardDelegate?
	internal var progressView		: LinearProgressView?

	// MARK: - Computed Properties

	internal var serializedEntity	: [String: Any] {
		// Override in subclass.
		fatalError("Must be overridden in subclass")
	}

	internal var imageData			: Data? {
		// If needed, override in subclass to upload an image.
		return nil
	}

	internal var contentType		: ContentType? {
		return self.contentDataSource?.contentType
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
		self.hideProgressView()
	}

	// MARK: - Setup Functions

	func setupUIElements() {
		// Override in subclass to init all outlets.

		// Configure the ProgressView for the current view.
		self.progressView = LinearProgressView(within: self.view, layoutSupport: self.topLayoutGuide)
	}

	func setup(with entity: Model?, contentDataSource: ContentManagerDataSource?, dashboardDelegate: DashboardDelegate?) {
		self.entity = entity
		self.contentDataSource = contentDataSource
		self.dashboardDelegate = dashboardDelegate
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

	/// This function:
	/// - Create or update a new entity.
	/// - Re-fetch the data for the current content type.
	/// - Reload the table view.
	/// - And finally, pop the current view controller.
	@IBAction func save() {
		// Show Linear Progress View
		self.showProgressView()
		// Create or Update entities entities through the API
		self.contentDataSource?.createOrUpdateEntity(json: self.serializedEntity, imageData: self.imageData, completion: { [weak self] in
			self?.dashboardDelegate?.reloadTableView()
			self?.navigationController?.popViewController(animated: true)
		})
	}
}
