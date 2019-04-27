//
//  ContentManagerDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

protocol ContentManagerDelegate {

	/// Reload the table view with the current datasource.
	///
	/// - Parameter deleteRows: Array of rows to delete with a fade animation. If empty nothing happens.
	func reloadContent(deleteRows: [IndexPath])
}
