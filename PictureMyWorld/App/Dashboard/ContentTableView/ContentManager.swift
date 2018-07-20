//
//  ContentManager.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ContentManager {

	public let contentType	: ContentType
	private var contentData	: [ContentType: [Any]]
	private var delegate 	: ContentManagerDelegate?

	init(type: ContentType, data: [ContentType: [Any]], delegate: ContentManagerDelegate) {
		self.contentType = type
		self.contentData = data
		self.delegate = delegate
	}
}

// MARK: - Getters

extension ContentManager {

	func model(at indexPath: IndexPath) -> Model? {
		return self.contentData[self.contentType]?[indexPath.row] as? Model
	}

	var models: [Any] {
		return (self.contentData[self.contentType] ?? [])
	}
}

// MARK: - Private Setters

extension ContentManager {

	func set(data: [Any], for contentType: ContentType) {
		let result = data.sorted(by: contentType.sorting)
		self.contentData[contentType] = result
	}
}

// MARK: - Public Utility functions

extension ContentManager {

	func refreshContent(deleteRows: [IndexPath] = []) {
		self.contentType.fetchEntities({ (result: [Any], error: Error?) in
			if let error = error {
				let controller = AppDelegate.alertPresentingController
				UIAlertController.showErrorMessage(error.localizedDescription, presentingViewController: controller)
			}

			self.set(data: result, for: self.contentType)
			self.delegate?.reloadContent(deleteRows: deleteRows)
		})
	}

	func presentDeleteContentAlert(for indexPath: IndexPath) {
		guard let model = self.model(at: indexPath) else {
			return
		}

		let alert = UIAlertController(title: nil, message: "Delete '\(model.title)' ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Go for it", style: .destructive, handler: { (_ : UIAlertAction) in
			self.deleteContent(for: indexPath)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		AppDelegate.alertPresentingController?.present(alert, animated: true, completion: nil)
	}
}

// MARK: - Private Utility functions

private extension ContentManager {

	func deleteContent(for indexPath: IndexPath) {
		guard let model = self.model(at: indexPath) else {
			return
		}

		self.contentType.deleteEntity(model.filename) { (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			self.refreshContent(deleteRows: [indexPath])
		}
	}
}
