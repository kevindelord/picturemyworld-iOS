//
//  DashboardDelegate.swift
//  PictureMyWorld
//
//  Created by kevindelord on 27/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import UIKit

protocol DashboardDelegate {

	/// Push a detail view controller to create or update a new model object.
	///
	/// - Parameters:
	///   - destination: Destination Type.
	///   - entity: Model object.
	func present(destination: DetailViewRooter.Destination, entity: Model?)

	/// Reload the content table view.
	func reloadTableView()

	// TODO: refactor ProgressView for iOS 11 + documentation
	var presentingView : UIView { get }
	var layoutGuide : UILayoutSupport { get }
}
