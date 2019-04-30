//
//  SDWebImage.swift
//
//  Created by kevin delord on 20/05/15.
//

import Foundation
import SDWebImage

// TODO: Update AssetManager

// MARK: - DownloadPriority

/// Download priority of each download operation.
///
/// - veryHigh: Operations receive very high priority for execution.
/// - high: Operations receive high priority for execution.
/// - normal: Operations receive the normal priority for execution.
/// - low: Operations receive low priority for execution.
/// - veryLow: Operations receive very low priority for execution.
enum DownloadPriority : Int {
	case veryHigh = 0
	case high
	case normal
	case low
	case veryLow

	/// Queue priority of the download opetation.
	fileprivate var queuePriority: Operation.QueuePriority {
		switch self {
		case .veryHigh:		return Operation.QueuePriority.veryHigh
		case .high:			return Operation.QueuePriority.high
		case .normal:		return Operation.QueuePriority.normal
		case .low:			return Operation.QueuePriority.low
		case .veryLow:		return Operation.QueuePriority.veryLow
		}
	}

	/// Quality of service of the download operation.
	fileprivate var quality: QualityOfService {
		switch self {
		case .veryHigh:		return QualityOfService.userInteractive
		case .high:			return QualityOfService.userInitiated
		case .normal:		return QualityOfService.utility
		case .low:			return QualityOfService.utility
		case .veryLow:		return QualityOfService.background
		}
	}
}

// MARK: - AssetManager

struct AssetManager {

	static var APIPassword					: String?
	static var APIUsername					: String?

	fileprivate static var operations		= [String: Operation]()
	fileprivate static let concurrentQueue	= DispatchQueue(label: "com.assetmanager.download.assetqueue", attributes: DispatchQueue.Attributes.concurrent)

	// MARK: - Private functions

	/// Optional path URL of the application's Documents directory.
	fileprivate static var applicationDocumentsDirectory: URL? {
		if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
			return URL(fileURLWithPath: path)
		}

		return nil
	}

	/// Function to write an image to the disk. Call the completion block with the imagePath.
	///
	/// - Parameters:
	///   - image: Image object to write to the disk
	///   - imageType: Type of the image
	///   - completion: Completion block called after success.
	static func writeImageDataToDisk(image: UIImage, imageType: String, completion: @escaping (_ imagePath: String?) -> Void) {
		guard let directoryURL = self.applicationDocumentsDirectory else {
			completion(nil)
			return
		}

		// Create image filename with extension
		let filename = "\(Date().timeIntervalSinceReferenceDate).\(imageType)"
		let imagePath = directoryURL.appendingPathComponent(filename).absoluteString

		DispatchQueue.global(qos: .background).async {

			// Write image data to disk
			let data = image.jpegData(compressionQuality: 100)
			print("Write image data to path: \(imagePath)")
			do {
				try data?.write(to: URL(fileURLWithPath: imagePath), options: .completeFileProtection)
				// SUCCESS: back on main thread, call the completion block with the image static path.
				DispatchQueue.main.async {
					// This is the static part of the URL string that never changes and that will be stored in core data
					let staticURLPart = imagePath.replacingOccurrences(of: directoryURL.absoluteString, with: "", options: [], range: nil)
					completion(staticURLPart)
				}
			} catch let error {
				// ERROR: back on main thread, log the error and call the completion block without static path.
				DispatchQueue.main.async {
					print(error)
					completion(nil)
				}
			}
		}
	}

	// MARK: - Remove/Delete Assets

	/// Function to remove all stored assets (user personal pictures and Web cached images).
	static func removeAllStoredAssets() {

		// User pictures
		if let directory = self.applicationDocumentsDirectory {

			let stringURL = directory.absoluteString
			let files = try? FileManager.default.contentsOfDirectory(atPath: stringURL)
			files?.forEach({ (filename: String) in
				let fileURL = directory.appendingPathComponent(filename)
				_ = self.deleteItem(atURL: fileURL)
			})
		}

		// Thumbnails and DB assets
		SDImageCache.shared().clearDisk()
		SDImageCache.shared().clearMemory()
	}

	/// Function to remove an item from the disk with a dedicated url.
	///
	/// - Parameter url: The url for the deleted item
	/// - Returns: true if succeded; false otherwise.
	static func deleteItem(atURL url: URL) -> Bool {
		// Remove item at path
		print("Remove asset item at url: \(url)")
		do {
			try FileManager.default.removeItem(at: url)
			return true
		} catch let error {
			print(error)
			return false
		}
	}

	/// Remove from the disk a SDWebImage cached file.
	///
	/// - Parameter imageURL: URL of the image
	static func removeCachedImage(_ imageURL: URL?) {
		if let url = imageURL?.absoluteString {
			SDImageCache.shared().removeImage(forKey: url)
		}
	}
}

extension AssetManager {

	// MARK: - Preload Images

	/// If the image does not exist locally, add the image URL in to the download queue.
	///
	/// - Parameters:
	///   - url: URL of the image to preload.
	///   - priority: Priority of the download operation.
	static func preloadImage(fromURL url: URL?, priority: DownloadPriority) {
		guard let url = url else {
			return
		}

		SDImageCache.shared().diskImageExists(withKey: url.absoluteString) { (isInCache: Bool) in
			if (isInCache == false) {
				self.addDownloadOperation(fromURL: url, priority: priority, completion: nil)
			}
		}
	}

	// MARK: - Download Images

	/// Add the image URL as an operation into the download queue.
	///
	/// - Parameters:
	///   - url: URL of the image to download.
	///   - priority: Priority of the download operation.
	///   - completion: Completion closure containing the downloaded image.
	static func downloadImage(fromURL url: URL?, priority: DownloadPriority, completion: ((_ image: UIImage?) -> Void)?) {
		guard let url = url else {
			completion?(nil)
			return
		}

		self.addDownloadOperation(fromURL: url, priority: priority, completion: completion)
	}

	/// Query and return a cached image.
	///
	/// - Parameters:
	///   - url: URL of the image to query from the cache.
	///   - completion: Completion closure containing the cached image.
	private static func queryCachedImage(fromURL url: URL, completion: ((_ image: UIImage?, _ imageKey: String) -> Void)?) {

		let imageKey = url.absoluteString
		// Check if image is already cached:
		SDImageCache.shared().queryCacheOperation(forKey: imageKey, done: { (image: UIImage?, data: Data?, type: SDImageCacheType) in

			// If any, return the image from the cache.
			print("Return cached image for KEY: \(imageKey)")
			completion?(image, imageKey)
		})
	}

	/// Download and cache an image using SDWebImage.
	///
	/// - Parameters:
	///   - url:			URL of the image to download.
	///   - completion: 	Completion closure containing the downloaded image.
	private static func downloadAndCacheImage(fromURL url: URL, completion: ((_ image: UIImage?, _ imageKey: String) -> Void)?) {

		let imageKey = url.absoluteString

		// Download image and cache on Disk
		SDWebImageDownloader.shared().username = self.APIUsername
		SDWebImageDownloader.shared().password = self.APIPassword

		print("Download and cache image from URL: \(imageKey)")
		SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions(), progress: nil) { (image: UIImage?, data: Data?, error: Error?, finished: Bool) in
			print("Download completed from URL: \(imageKey)")
			if (finished == true), let image = image {
				print("Write to disk and add Backup attribute for item from URL: \(imageKey)")
				self.storeImageWithBackupAttribute(at: url, image: image)
			}

			completion?(image, imageKey)
		}
	}

	/// Private function to add the image URL into the download queue depending on the priority.
	///
	/// If the image URL is already waiting to be downloaded, cancel the operation and replace it with a new one (The priority could be different).
	///
	/// - Parameters:
	///   - url: URL of the image to download.
	///   - priority: Priority of the download operation.
	///   - completion: Completion closure containing the downloaded image.
	private static func addDownloadOperation(fromURL url: URL?, priority: DownloadPriority, completion: ((_ image: UIImage?) -> Void)?) {

		guard let imageURL = url else {
			completion?(nil)
			return
		}

		let imageURLKey = imageURL.absoluteString
		var operation: Operation?
		// Check if operation already exist
		self.concurrentQueue.sync {
			operation = self.operations[imageURLKey] as Operation?
		}

		if let operation = operation {
			guard (operation.isExecuting == false) else {
				// If the image is currently being downloaded then do nothing, just wait.
				print("Operation already in process: \(imageURLKey)")
				return
			}

			// Otherwise, cancel the operation and create a new one.
			operation.cancel()
			print("Cancel download operation: \(imageURLKey)")
		}

		// Create a new operation and configure its quality of service and queue priority
		let downloadOperation = self.downloadOperation(fromURL: imageURL, priority: priority, completion: completion)

		// Add or replace the operation
		self.concurrentQueue.sync {
			self.operations[imageURLKey] = downloadOperation
			OperationQueue.main.addOperation(downloadOperation)
		}
	}

	/// Create and configure a new download block operation.
	///
	/// - Parameters:
	///   - imageURL: 	URL of the image to download.
	///   - priority: 	Download priority.
	///   - completion:	Completion closure containing the downloaded image.
	/// - Returns: A new block operation configure to download an image with the correct priority.
	private static func downloadOperation(fromURL imageURL: URL, priority: DownloadPriority, completion: ((_ image: UIImage?) -> Void)?) -> BlockOperation {

		// Create new BlockOperation
		let operation = BlockOperation {

			let handler = { (image: UIImage?, imageKey: String) in
				image?.accessibilityIdentifier = imageKey
				completion?(image)
				self.concurrentQueue.sync {
					self.operations.removeValue(forKey: imageKey)
					return
				}
			}

			// Query the cached image first.
			self.queryCachedImage(fromURL: imageURL) { (image: UIImage?, imageKey: String) in

				guard let image = image else {
					// If the image has not been downloaded yet, starts the process and set the backup key to NO.
					self.downloadAndCacheImage(fromURL: imageURL, completion: handler)
					return
				}

				// Otherwise return the image through the completion block.
				handler(image, imageKey)
			}
		}

		// Configure the quality of service and queue priority
		operation.qualityOfService = priority.quality
		operation.queuePriority = priority.queuePriority

		return operation
	}

	/// Get the default cache path for a certain key
	///
	/// - Parameter key: The key of the stored image.
	/// - Returns: the default cache path
	static func cachePath(forKey key: String?) -> String? {
		return SDImageCache.shared().defaultCachePath(forKey: key)
	}
}

// MARK: - ICloud Skip attribute

extension AssetManager {

	/// Checks if a file has its `NSURLIsExcludedFromBackupKey` boolean value set. If so, retuns the value; otherwise returns false.
	///
	/// - Parameter fileUrl: URL of the file on the disk.
	/// - Returns: true if the file is excluded; false otherwise.
	private static func checkSkipBackupAttribute(forFileURL fileUrl: URL) -> Bool {

		do {
			let isExcluded = try fileUrl.resourceValues(forKeys: [.isExcludedFromBackupKey])
			return (isExcluded.isExcludedFromBackup ?? false)
		} catch {
			return false
		}
	}

	/// Add the `NSURLIsExcludedFromBackupKey` value set to NO for the given filepath.
	///
	/// - Parameter fileUrl: URL of the file on the disk.
	/// - Returns: true if the resource property is successfully set; false otherwise.
	private static func addSkipBackupAttribute(forFileURL fileUrl: URL) -> Bool {
		// Set NSURLIsExcludedFromBackupKey=NO for the file. code is taken from Apples iOS Dev Library
		print("Exclude item from Backup at url: \(fileUrl)")

		do {
			var urlToExclude = fileUrl
			var resourceValues = URLResourceValues()
			resourceValues.isExcludedFromBackup = true
			try urlToExclude.setResourceValues(resourceValues)
			return true
		} catch let error {
			print("error: \(error)")
			return false
		}
	}

	/// Recursive function to add backup key to file after it has been completely stored.
	///
	/// - Parameters:
	///   - url: URL of the file on the disk.
	///   - image: UIImage object to store and cache on the disk.
	///   - attempt: Number of attempts to cache the image. Used to control the recursivity of the function and avoid infinite loop.
	static func storeImageWithBackupAttribute(at url: URL, image: UIImage, attempt: Int = 0) {
		// This function should be called only AFTER a successful image download.
		// The storing function (to create a file on the disk out of some data in the memory) takes some times.
		// As there is NO way to know when this task will be done we need to check AFTER a delay if the file
		// Exists and then set the attributes.
		// We recurse the process until the file is present and correctly set.
		let filePath = url.absoluteString
		if (attempt == 0) {
			print("Cache image for KEY: \(filePath)")
			SDImageCache.shared().store(image, forKey: filePath)
		}

		let maxAttempts = 20
		guard (attempt >= 0 && attempt < maxAttempts) else {
			print("ERROR storing image with backup attributes. File Path: \(filePath)")
			return
		}

		guard let cachePath = SDImageCache.shared().defaultCachePath(forKey: filePath) else {
			return
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			AssetManager.checkCacheStatus(at: url, cachePath: cachePath, image: image, attempt: attempt)
		}
	}

	/// Verify and cache if necessary the backup attribute of an image.
	///
	/// - Parameters:
	///   - url: URL of the file on the disk.
	///   - cachePath: String path representing the location of the cached image on the disk.
	///   - image: UIImage object to store and cache on the disk.
	///   - attempt: Number of attempts to cache the image. Used to control the recursivity of the function and avoid infinite loops.
	private static func checkCacheStatus(at url: URL, cachePath: String, image: UIImage, attempt: Int) {
		let fileURL = URL(fileURLWithPath: cachePath)
		guard
			((FileManager.default.fileExists(atPath: cachePath) == true) &&
			(self.addSkipBackupAttribute(forFileURL: fileURL) == true) &&
			(self.checkSkipBackupAttribute(forFileURL: fileURL) == true)) else {
				print("ERROR trying to cache the image again... new attempt: \(attempt + 1)")
				self.storeImageWithBackupAttribute(at: url, image: image, attempt: attempt + 1)
				return
		}

		print("Cache completed!")
	}
}
