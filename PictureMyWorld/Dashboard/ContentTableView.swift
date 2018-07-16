//
//  ContentTableView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ContentTableView 					: UITableView {

	private var contentType				= ContentType.defaultType
	private var contentData				= ContentType.defaultData
	private var detailViewRooter		: DetailViewRooter?

	func load(for type: ContentType, rooter: DetailViewRooter?) {
		self.contentType = type
		self.detailViewRooter = rooter
		self.delegate = self
		self.dataSource = self
		// Reload the table view when if is the content might not exist yet.
		self.reloadData()

		if (self.contentData[self.contentType]?.isEmpty == true) {
			// Otherwise fetch the content from the API and then reload the table view.
			self.refreshContent(for: self.contentType)
		}
	}

	func refreshContent(for type: ContentType) {
		type.fetch?({ (result: [Any], error: Error?) in
			if let error = error {
				let controller = AppDelegate.alertPresentingController
				UIAlertController.showErrorMessage(error.localizedDescription, presentingViewController: controller)
			}

			self.contentData[type] = result
			self.reloadData()
		})
	}
}

extension ContentTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return self.contentType.heightForRow
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let entity = self.contentData[self.contentType]?[indexPath.row] as? Serializable else {
			fatalError("cannot retrieve model object.")
		}

		self.detailViewRooter?.present(destination: self.contentType.destination, entity: entity)
	}
}

extension ContentTableView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.contentData[self.contentType]?.count ?? 0)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: self.contentType.reuseIdentifier) else {
			return UITableViewCell()
		}

		self.contentType.update(cell: cell, with: self.contentData[self.contentType]?[indexPath.row])
		return cell
	}

	override var numberOfSections: Int {
		return 1
	}
}
