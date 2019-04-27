//
//  ContentTableView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ContentTableView 					: UITableView {

	private var contentDataSource		: ContentManagerDataSource?
	private var contentDelegate			: ContentManagerDelegate?
	private var dashboardDelegate		: DashboardDelegate?

	func setup(with dataSource: ContentManagerDataSource, contentDelegate: ContentManagerDelegate, dashboardDelegate: DashboardDelegate?) {
		self.delegate = self
		self.dataSource = self
		self.contentDataSource = dataSource
		self.contentDelegate = contentDelegate
		self.dashboardDelegate = dashboardDelegate

		// Setup Refresh Contol
		self.refreshControl =  UIRefreshControl()
		self.refreshControl?.tintColor = self.tintColor
		self.refreshControl?.addTarget(self, action: #selector(self.reloadContentManager), for: .valueChanged)

		// Fetch the content from the API and then reload the table view.
		self.reloadContentManager()
	}

	@objc private func reloadContentManager() {
		self.contentDataSource?.refreshContent(completion: {
			self.reloadData()
			// If any, stop the refreshing animation
			self.refreshControl?.endRefreshing()
		})
	}
}

// MARK: - ContentManagerDelegate

extension ContentTableView {

	/// Reload the table view with the current datasource.
	/// If there is no data for the current type, it fetches the entities from the API.
	///
	/// - Parameter deleteRows: Array of rows to delete with a fade animation. If empty nothing happens.
	func reloadContent(deleteRows: [IndexPath]) {
		if (deleteRows.isEmpty == false) {
			self.deleteRows(at: deleteRows, with: .fade)
		} else {
			if (self.contentDataSource?.modelsCount == 0) {
				self.reloadContentManager()
			} else {
				self.reloadData()
			}
		}

		// If any, stop the refreshing animation
		self.refreshControl?.endRefreshing()
	}
}

// MARK: - UITableViewDelegate

extension ContentTableView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (self.contentDataSource?.contentType.heightForRow ?? 0)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard
			let entity = self.contentDataSource?.model(at: indexPath),
			let destination = self.contentDataSource?.contentType.destination else {
				fatalError("cannot retrieve model object.")
		}

		self.dashboardDelegate?.present(destination: destination, entity: entity)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			self.presentDeleteContentAlert(for: indexPath)
		}
	}

	private func presentDeleteContentAlert(for indexPath: IndexPath) {
		guard let model = self.contentDataSource?.model(at: indexPath) else {
			return
		}

		let alert = UIAlertController(title: nil, message: "Delete '\(model.title)' ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Go for it", style: .destructive, handler: { (_ : UIAlertAction) in
			self.contentDelegate?.deleteContent(for: indexPath, completion: { [weak self] (row: IndexPath) in
				self?.reloadContent(deleteRows: [row])
			})
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		AppDelegate.alertPresentingController?.present(alert, animated: true, completion: nil)
	}
}

// MARK: - UITableViewDataSource

extension ContentTableView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.contentDataSource?.modelsCount ?? 0)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let identifier = self.contentDataSource?.contentType.reuseIdentifier,
			let cell = tableView.dequeueReusableCell(withIdentifier: identifier),
			let model = self.contentDataSource?.model(at: indexPath) else {
				return UITableViewCell()
		}

		self.contentDataSource?.contentType.update(cell: cell, with: model)
		return cell
	}

	override var numberOfSections: Int {
		return 1
	}
}
