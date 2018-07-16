//
//  ContentTableView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

// TODO: Integrate pull to refresh
// TODO: Seprate logic Content Management

class ContentTableView 					: UITableView {

	private var contentType				= ContentType.defaultType
	private var contentData				= ContentType.defaultData
	private var detailViewRooter		: DetailViewRooter?

	func load(for type: ContentType, rooter: DetailViewRooter?) {
		self.contentType = type
		self.detailViewRooter = rooter
		self.delegate = self
		self.dataSource = self

		// Otherwise fetch the content from the API and then reload the table view.
		self.refreshContent()
	}
}

// MARK: Content Management

fileprivate extension ContentTableView {

	func refreshContent(deleteRows: [IndexPath] = []) {
		self.contentType.fetchEntities({ [weak self] (result: [Any], error: Error?) in
			if let error = error {
				let controller = AppDelegate.alertPresentingController
				UIAlertController.showErrorMessage(error.localizedDescription, presentingViewController: controller)
			}

			guard let type = self?.contentType else {
				return
			}

			self?.contentData[type] = result
			if (deleteRows.isEmpty == false) {
				self?.deleteRows(at: deleteRows, with: .fade)
			} else {
				self?.reloadData()
			}
		})
	}

	func deleteContent(for indexPath: IndexPath) {
		guard let model = self.model(at: indexPath) else {
			return
		}

		self.contentType.deleteEntity(model.filename) { [weak self] (error: Error?) in
			guard (error == nil) else {
				UIAlertController.showErrorPopup(error as NSError?)
				return
			}

			self?.refreshContent(deleteRows: [indexPath])
		}
	}

	func presentDeleteContentAlert(for indexPath: IndexPath) {
		guard let model = self.model(at: indexPath) else {
			return
		}

		let alert = UIAlertController(title: nil, message: "Delete '\(model.title)' ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Go for it", style: .destructive, handler: { [weak self] (_ : UIAlertAction) in
			self?.deleteContent(for: indexPath)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		AppDelegate.alertPresentingController?.present(alert, animated: true, completion: nil)
	}

	func model(at indexPath: IndexPath) -> Model? {
		return self.contentData[self.contentType]?[indexPath.row] as? Model
	}
}

// MARK: - UITableViewDelegate

extension ContentTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.contentType.heightForRow
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let entity = self.model(at: indexPath) else {
			fatalError("cannot retrieve model object.")
		}

		self.detailViewRooter?.present(destination: self.contentType.destination, entity: entity)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			self.presentDeleteContentAlert(for: indexPath)
		}
	}
}

// MARK: - UITableViewDataSource

extension ContentTableView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.contentData[self.contentType]?.count ?? 0)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: self.contentType.reuseIdentifier) else {
			return UITableViewCell()
		}

		self.contentType.update(cell: cell, with: self.model(at: indexPath))
		return cell
	}

	override var numberOfSections: Int {
		return 1
	}
}
