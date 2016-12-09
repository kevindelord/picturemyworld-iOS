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
	var urlString			: String

	init(urlString: String) {
		self.urlString = urlString
		super.init()
	}

	func fetchImage(completionBlock: ((image: UIImage?) -> Void)) {
//		AssetManager.downloadImage(self.urlString, priority: DownloadPriority.Low) { (image: UIImage?) in
//			completionBlock(image: image)
//		}

		guard let url = NSURL(string: self.urlString) else {
			return
		}
		SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageDownloaderOptions(), progress: nil) {(image: UIImage!, data: NSData!, error: NSError!, finished: Bool) in
			completionBlock(image: image)
		}
	}
}
