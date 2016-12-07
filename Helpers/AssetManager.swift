//
//  SDWebImage.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 06/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import SDWebImage

// MARK: - DownloadPriority

enum DownloadPriority : Int {
	case VeryHigh = 0
	case High
	case Normal
	case Low
	case VeryLow

	func queuePriority() -> NSOperationQueuePriority {
		switch self {
		case .VeryHigh:     return NSOperationQueuePriority.VeryHigh
		case .High:         return NSOperationQueuePriority.High
		case .Normal:       return NSOperationQueuePriority.Normal
		case .Low:          return NSOperationQueuePriority.Low
		case .VeryLow:      return NSOperationQueuePriority.VeryLow
		}
	}

	func quality() -> NSQualityOfService {
		switch self {
		case .VeryHigh:     return NSQualityOfService.UserInteractive
		case .High:         return NSQualityOfService.UserInitiated
		case .Normal:       return NSQualityOfService.Utility
		case .Low:          return NSQualityOfService.Utility
		case .VeryLow:      return NSQualityOfService.Background
		}
	}
}

// MARK: - AssetManager

struct AssetManager {

	internal static var APIPassword     : String?
	internal static var APIUsername     : String?

	private static var operations       = [String:NSOperation]()
	private static let concurrentQueue  = dispatch_queue_create("com.assetmanager.download.assetqueue", DISPATCH_QUEUE_CONCURRENT)

	// MARK: - Private functions

	/**
	* Returns the URL to the application's Documents directory.
	*/
	private static func getApplicationDocumentsDirectory() -> NSURL? {
		if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
			return NSURL(fileURLWithPath: path)
		}
		return nil
	}
	/**
	* Function to write an image to the disk. Call the completion block with the imagePath.

	- parameter image:           image
	- parameter imageType:       type of the image
	- parameter completionBlock: path of the written image
	*/
	static func writeImageDataToDisk(image: UIImage, imageType: String, completionBlock: (imagePath: String?) -> Void) {
		// Create image path
		let url = "\(NSDate().timeIntervalSinceReferenceDate).\(imageType)"

		if let directoryURL = self.getApplicationDocumentsDirectory() {
			let imagePath = directoryURL.URLByAppendingPathComponent(url).absoluteString
			// This is the static part of the URL string that never changes and that will be stored in core data
			let staticURLPart = imagePath.stringByReplacingOccurrencesOfString(directoryURL.absoluteString, withString: "", options: [], range: nil)

			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {

				// Write image data to disk
				let data = UIImageJPEGRepresentation(image, 100)
				DKLog(Verbose.Manager.Asset, "Write image data to path: \(imagePath)")
				do {
					try data?.writeToFile(imagePath, options: .DataWritingFileProtectionComplete)
					// SUCCESS: back on main thread display call the completion block with the image static path.
					dispatch_async(dispatch_get_main_queue()) {
						completionBlock(imagePath: staticURLPart)
					}

				} catch let error as NSError {
					// ERROR: back on main thread display the error and call completion block without static path.
					dispatch_async(dispatch_get_main_queue()) {
						UIAlertView.showErrorPopup(error)
						completionBlock(imagePath: nil)
					}
				}
			}
		}
	}

	// MARK: - Remove/Delete Assets

	/**
	* Function to remove all stored assets (user personnal pictures and Web cached images).
	*/
	static func removeAllStoredAssets() {

		// User pictures
		if let
			directory = self.getApplicationDocumentsDirectory(),
			files = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(directory.absoluteString) {
				for file in (files ?? []) {
					let fileURL = directory.URLByAppendingPathComponent(file)
					self.deleteItemAtURL(fileURL)
				}
		}
		// Thumbnails and DB assets
		SDImageCache.sharedImageCache().clearDisk()
		SDImageCache.sharedImageCache().clearMemory()
	}

	/**
	Function to remove an item from the disk with a dedicated url

	- parameter url: the url for the deleted item
	- returns: true if succeded
	*/
	static func deleteItemAtURL(url: NSURL) -> Bool {
		// Remove item at path
		DKLog(Verbose.Manager.Asset, "Remove asset item at url: \(url)")
		do {
			try NSFileManager.defaultManager().removeItemAtURL(url)
			return true

		} catch let error as NSError {
			UIAlertView.showErrorMessage(error.localizedDescription)
			return false
		}
	}

	/**
	Remove from the disk a SDWebImage cached file.
	- parameter imageURL: url of the image
	*/
	static func removeCachedImage(imageURL: String?) {
		if let _imageURL = imageURL {
			SDImageCache.sharedImageCache().removeImageForKey(_imageURL)
		}
	}
}

extension AssetManager {

	// MARK: - Preload Images

	/**
	If the image does not exist locally, add the image URL in to the download queue.
	- parameter imageURL: url of the provided image
	- parameter priority: priority
	*/
	static func preloadImage(imageURL: String?, priority: DownloadPriority) {
		guard let imageURL = imageURL else {
			return
		}
		SDImageCache.sharedImageCache().diskImageExistsWithKey(imageURL) { (isInCache: Bool) in
			if (isInCache == false) {
				self.downloadImageAtUrl(imageURL, priority: priority, completion: nil)
			}
		}
	}

	// MARK: - Download Images

	/**
	Add the image URL in to the download queue.

	- parameter url:        image url
	- parameter priority:   download priority
	- parameter completion: the downloaded image
	*/
	static func downloadImage(url: String?, priority: DownloadPriority, completion: ((image: UIImage?) -> Void)?) {
		guard let url = url else {
			return
		}
		self.downloadImageAtUrl(url, priority: priority, completion: completion)
	}

	/**
	Function to query and return the cached image. If it has not been downloaded yet, starts the process and set the backup key to NO.

	- parameter imageURL:   url of the image
	- parameter completion:  sends the new image back.
	*/
	private static func downloadAndCacheImage(imageURL: String?, completion: ((image: UIImage?) -> Void)?) {

		guard let
			_imageURL = imageURL,
			url = NSURL(string: _imageURL) else {
				return
		}
		// Check if image is already cached:
		SDImageCache.sharedImageCache().queryDiskCacheForKey(_imageURL, done: { (image: UIImage!, type: SDImageCacheType) in
			// If there is and image in Cache, return it.
			guard (image == nil) else {
				DKLog(Verbose.Manager.Asset, "Return cached image for KEY: \(_imageURL)")
				completion?(image: image)
				return
			}
			// If not, download image and chache on Disk
			SDWebImageDownloader.sharedDownloader().username = self.APIUsername
			SDWebImageDownloader.sharedDownloader().password = self.APIPassword
			DKLog(Verbose.Manager.Asset, "Download and cache image from URL: \(_imageURL)")
			SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageDownloaderOptions(), progress: nil) {(image: UIImage!, data: NSData!, error: NSError!, finished: Bool) in
				DKLog(Verbose.Manager.Asset, "Download completed from URL: \(_imageURL)")
				if (image != nil && finished == true) {
					DKLog(Verbose.Manager.Cache, "Write to disk and add Backup attribute for item from URL: \(_imageURL)")
					self.storeImageWithBackupAttribute(_imageURL, image: image)
				}
				completion?(image: image)
			}
		})
	}

	// MARK: - Operation Queue

	/**
	Private function to add the image URL in to the download queue depending on the priority.
	If the image URL is already waiting to be downloaded, cancel the operation and replace it with a new one (The priority could be different).
	- parameter url:        image url
	- parameter priority:   download priority
	- parameter completion: returned image
	*/
	private static func downloadImageAtUrl(url: String?, priority: DownloadPriority, completion: ((image: UIImage?) -> Void)?) {

		guard let imageURL = url else {
			return
		}

		var operation: NSOperation?
		// Check if operation already exist
		dispatch_sync(self.concurrentQueue) {
			operation = self.operations[imageURL] as NSOperation?
		}

		if (operation != nil) {
			if (operation?.executing == true) {
				// If the image is currently being downloaded then do nothing, just wait.
				return
			}
			// Otherwise, cancel the operation and create a new one.
			operation?.cancel()
			DKLog(Verbose.Manager.Asset, "Cancel download operation: \(imageURL)")
		}

		// Create new operation
		operation = NSBlockOperation {
			self.downloadAndCacheImage(imageURL) { (image: UIImage?) in
				completion?(image: image)
				dispatch_sync(self.concurrentQueue) {
					self.operations.removeValueForKey(imageURL)
					return
				}
			}
		}
		// Configure the quality of service and queue priority
		operation?.qualityOfService = priority.quality()
		operation?.queuePriority = priority.queuePriority()
		// Add or replace the operation
		dispatch_sync(self.concurrentQueue) {
			if let _ope = operation {
				self.operations[imageURL] = _ope
				NSOperationQueue.mainQueue().addOperation(_ope)
			}
		}
	}
}

extension AssetManager {

	// MARK: -  iCloud Skip attribute
	/**
	Checks if a file as its NSURLIsExcludedFromBackupKey value set.If so retuns the value, otherwise false.

	- parameter filename: filename
	- returns: true if thmubnail is available
	*/
	static func checkSkipBackupAttribute(filename:String) -> Bool {
		let url = NSURL(fileURLWithPath: filename)
		var thumbnails: AnyObject?

		do {
			try url.getResourceValue(&thumbnails, forKey: NSURLIsExcludedFromBackupKey)
			return ((thumbnails as? NSNumber)?.boolValue ?? false)

		} catch {
			return false
		}
	}

	/**
	Add the NSURLIsExcludedFromBackupKey value set to NO for the given filepath.Returns YES if the resource property named key is successfully set to value; otherwise, NO.

	- parameter filename: filename
	- returns: true if the resource property named key is successfully set to value
	*/
	static func addSkipBackupAttributeToItemWithFileName(filename:String) -> Bool {
		// Set NSURLIsExcludedFromBackupKey=NO for the file. code is taken from Apples iOS Dev Library
		let url = NSURL(fileURLWithPath: filename)
		DKLog(Verbose.Manager.Cache, "Exclude item from Backup at path: \(url)")
		do {
			try url.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
			return true

		} catch let error as NSError {
			DKLog(Verbose.Error, error)
			return false
		}
	}

	/**
	Recursive function to add backup key to file after it has been completely stored.

	- parameter filePath: file path
	- parameter image:    image
	- parameter attempt:  number of attemps to cache image
	*/
	static func storeImageWithBackupAttribute(filePath: String, image: UIImage, attempt: Int = 0) {
		// This function should be called only AFTER a successful image download.
		// The storing function (to create a file on the disk out of some data in the memory) takes some times.
		// As there is NO way to know when this task will be done we need to check AFTER a delay if the file
		// Exists and then set the attributes.
		// We recurse the process until the file is present and correctly set.
		if (attempt == 0) {
			DKLog(Verbose.Manager.Cache, "Cache image for KEY: \(filePath)")
			SDImageCache.sharedImageCache().storeImage(image, forKey: filePath)
		}
		let maxAttempts = 20
		if (attempt >= 0 && attempt < maxAttempts) {
			NSObject.performBlockAfterDelay(0.1) {
				if let path = SDImageCache.sharedImageCache().defaultCachePathForKey(filePath)
					where ((NSFileManager.defaultManager().fileExistsAtPath(path) == true) &&
						(self.addSkipBackupAttributeToItemWithFileName(path) == true) &&
						(self.checkSkipBackupAttribute(path) == true)) {
							DKLog(Verbose.Manager.Cache, "Cache completed!")
							return
				}
				self.storeImageWithBackupAttribute(filePath, image: image, attempt: attempt + 1)
			}
		} else {
			print("ERROR storing image with backup attributes. File Path: \(filePath)")
		}
	}
}
