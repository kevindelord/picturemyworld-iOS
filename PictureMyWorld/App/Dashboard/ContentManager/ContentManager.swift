//
//  ContentManager.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ContentManager				: ContentManagerDataSource, ContentManagerDelegate {

	internal var contentType		: ContentType = ContentType.defaultType
	private var contentData			: [ContentType: [Any]] = ContentType.defaultData
}

// MARK: - Getters

extension ContentManager {

	internal func model(at indexPath: IndexPath) -> Model? {
		guard (self.contentData[self.contentType]?.isEmpty == false) else {
			return nil
		}

		return self.contentData[self.contentType]?[indexPath.row] as? Model
	}

	internal var modelsCount: Int{
		return (self.contentData[self.contentType] ?? []).count
	}
}

// MARK: - DataSource Utility functions

extension ContentManager {

	internal func fetchContent(completion: @escaping (() -> Void)) {
		self.contentType.fetchEntities({ (result: [Any], error: Error?) in
			if let error = error {
				let controller = AppDelegate.alertPresentingController
				UIAlertController.showErrorMessage(error.localizedDescription, presentingViewController: controller)
			}

			self.set(data: result, for: self.contentType)
			completion()
		})
	}

	private func set(data: [Any], for contentType: ContentType) {
		let result = data.sorted(by: contentType.sorting)
		self.contentData[contentType] = result
	}

	internal func createOrUpdateEntity(json: [String : Any], imageData: Data?, completion: @escaping () -> Void) {
		self.contentType.createOrUpdateEntity(json, imageData) { [weak self] (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			// Re-Fetch the data, reload the table view and pop the current view controller.
			self?.fetchContent(completion: {
				completion()
			})
		}
	}
}

// MARK: - Delegate Utility functions

extension ContentManager {

	/// Delete an entry from the API and refetch the latest status.
	/// The (re-)fetch of the entities for the current content type is important to render the tableView without errors.
	internal func deleteContent(for indexPath: IndexPath, completion: @escaping ((IndexPath) -> Void)) {
		guard let model = self.model(at: indexPath) else {
			return
		}

		self.contentType.deleteEntity(model.filename) { [weak self] (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			self?.fetchContent(completion: {
				completion(indexPath)
			})
		}
	}
}
