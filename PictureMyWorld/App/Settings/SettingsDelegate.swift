//
//  SettingsDelegate.swift
//  PictureMyWorld
//
//  Created by kevindelord on 28/04/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

// TODO: add documentation

protocol SettingsDelegate {

	/// Open the Web Preview controller to display the web page related to the given environment.
	///
	/// - Parameter environment: Environment to open the web page.
	func previewWebsite(for environment: Environment?)

	/// Deploy active changes made to a specific environment.
	///
	/// - Parameter environment: Environment to deploy the changes to.
	func deploy(to environment: Environment?)
}
