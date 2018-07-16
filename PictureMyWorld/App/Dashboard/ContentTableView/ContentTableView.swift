//
//  ContentTableView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

// TODO: Integrate pull to refresh

class ContentTableView 					: UITableView {

	private var contentManager			: ContentManager?
	private var detailViewRooter		: DetailViewRooter?

	func load(for type: ContentType, rooter: DetailViewRooter?) {
		self.contentManager = ContentManager(type: type, data: ContentType.defaultData, delegate: self)
		self.delegate = self
		self.dataSource = self
		self.detailViewRooter = rooter

		// Otherwise fetch the content from the API and then reload the table view.
		self.contentManager?.refreshContent()
	}
}

// MARK: - ContentManagerDelegate

extension ContentTableView: ContentManagerDelegate {

	func reloadContent(deleteRows: [IndexPath]) {
		if (deleteRows.isEmpty == false) {
			self.deleteRows(at: deleteRows, with: .fade)
		} else {
			self.reloadData()
		}
	}
}

// MARK: - UITableViewDelegate

extension ContentTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (self.contentManager?.contentType.heightForRow ?? 0)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard
			let entity = self.contentManager?.model(at: indexPath),
			let destination = self.contentManager?.contentType.destination else {
				fatalError("cannot retrieve model object.")
		}

		self.detailViewRooter?.present(destination: destination, entity: entity)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			self.contentManager?.presentDeleteContentAlert(for: indexPath)
		}
	}
}

// MARK: - UITableViewDataSource

extension ContentTableView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.contentManager?.models.count ?? 0)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let identifier = self.contentManager?.contentType.reuseIdentifier,
			let cell = tableView.dequeueReusableCell(withIdentifier: identifier),
			let model = self.contentManager?.model(at: indexPath) else {
				return UITableViewCell()
		}

		self.contentManager?.contentType.update(cell: cell, with: model)
		return cell
	}

	override var numberOfSections: Int {
		return 1
	}
}
