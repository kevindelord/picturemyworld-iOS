//
//  AssetManagerSource.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 09/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AssetManagerSource	: NSObject, InputSource {
	var imageURLString		: String
	var thumbnailURLString	: String

	init(imageURLString: String, thumbnailURLString: String) {
		self.imageURLString = imageURLString
		self.thumbnailURLString = thumbnailURLString
		super.init()
	}

	func fetchImage(completionBlock: ((image: UIImage?) -> Void)) {
		// First load the thumbnail. As it should be already downloaded/preloaded, the callback will be directly called with the picture from the disk.
		AssetManager.downloadImage(self.thumbnailURLString, priority: DownloadPriority.Low) { (image: UIImage?) in
			completionBlock(image: image)
		}
		// Then load and display the real 'big' image.
		AssetManager.downloadImage(self.imageURLString, priority: DownloadPriority.Low) { (image: UIImage?) in
			completionBlock(image: image)
		}
	}
}
