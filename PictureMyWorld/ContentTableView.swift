//
//  ContentTableView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

enum ContentType {
	case posts
	case countries
	case videos

	static var defaultType : ContentType = .posts

	var fetch: ((@escaping (([Any], Error?) -> Void)) -> Void)? {
		switch self {
		case .posts			: return PostManager.fetchEntities
		case .countries		: return nil
		case .videos		: return nil
		}
	}

	var reuseIdentifier: String {
		switch self {
		case .posts			: return "post_list_cell_view"
		case .countries		: return ""
		case .videos		: return ""
		}
	}

	func update(cell: UITableViewCell, with data: Any?) {
		switch self {
		case .posts			: (cell as? PostTableViewCell)?.update(with: data as? Post)
		case .countries		: print("TODO")
		case .videos		: print("TODO")
		}
	}

	var heightForRow: CGFloat {
		switch self {
		case .posts			: return 98.0
		case .countries		: return 30.0
		case .videos		: return 30.0
		}
	}
}

class ContentTableView 			: UITableView {

	private var contentType		= ContentType.defaultType
	private var contentData		= [ContentType: [Any]]()

	func load(for type: ContentType) {
		self.contentType = type
		self.delegate = self
		self.dataSource = self

		if (self.contentData[self.contentType]?.isEmpty == false) {
			// Reload the table view is the content already exists.
			self.reloadData()
		} else {
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
