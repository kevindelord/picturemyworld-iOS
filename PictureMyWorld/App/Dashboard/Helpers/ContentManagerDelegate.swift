//
//  ContentManagerDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

protocol ContentManagerDelegate {

	/// Delete a specific content related to a given IndexPath.
	///
	/// - Parameters:
	///   - indexPath: IndexPath of the item to delete.
	///   - completion: Closure called after success with the indexPath of the deleted item.
	func deleteContent(for indexPath: IndexPath, completion: @escaping ((IndexPath) -> Void))
}
