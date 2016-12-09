//
//  AssetManagerSource.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 09/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import UIKit

class AssetManagerSource	: NSObject, InputSource {
	var urlString			: String

	init(urlString: String) {
		self.urlString = urlString
		super.init()
	}

	func fetchImage(completionBlock: ((image: UIImage?) -> Void)) {
		AssetManager.downloadImage(self.urlString, priority: DownloadPriority.Low) { (image: UIImage?) in
			completionBlock(image: image)
		}
	}
}
