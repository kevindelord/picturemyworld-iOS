//
//  ContentManagerDelegate.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 16.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import Foundation

protocol ContentManagerDelegate {

	func reloadContent(deleteRows: [IndexPath])
}
