//
//  ContentManagerDataSource.swift
//  PictureMyWorld
//
//  Created by kevindelord on 27/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import Foundation

protocol ContentManagerDataSource {

	/// Current Content Type of the ContentManager
	var contentType	: ContentType { get set }

	/// Total number of entities available for the current content type.
	var modelsCount: Int { get }

	/// Entity for a given IndexPath for the current content type.
	///
	/// - Parameter indexPath: IndexPath of the object to retrieve.
	/// - Returns: Optional entity found for the the current content type.
	func model(at indexPath: IndexPath) -> Model?

	/// Fetch and store the entities related to the current content type.
	///
	/// - Parameter completion: Closure called after success.
	func fetchContent(completion: @escaping (() -> Void))

	/// Create or update an entity based on the current content type of the ContentManager.
	///
	/// - Parameters:
	///   - json: Serialized Entity to create or update.
	///   - imageData: Optional image data.
	///   - completion: Closure calld after success.
	func createOrUpdateEntity(json: [String: Any], imageData: Data?, completion: @escaping () -> Void)
}


