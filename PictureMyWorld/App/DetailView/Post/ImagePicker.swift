//
//  ImagePicker.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import Photos

class ImagePicker	: UIImagePickerController {

	var completion	: ((Data?, Date?, CLLocation?) -> Void)?

	convenience init(completion: (@escaping ((Data?, Date?, CLLocation?) -> Void))) {
		self.init()

		self.allowsEditing = false
		self.sourceType = .photoLibrary
		self.delegate = self
		self.completion = completion

		let status = PHPhotoLibrary.authorizationStatus()
		if (status == .notDetermined) {
			PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
			})
		}
	}
}

extension ImagePicker: UIImagePickerControllerDelegate {

	/// New size of the PHAsset conforming to the Server scaling configuration.
	///
	/// - Parameter asset: The PHAsset to resize.
	/// - Returns: The new CGSize of the PHAsset.
	private func downscaledSize(for asset: PHAsset) -> CGSize {
		let width = Double(asset.pixelWidth)
		let height = Double(asset.pixelHeight)
		let maxSize = API.Upload.maximumImageSize

		var size = CGSize.zero
		if (height > width) {
			let scale = (Double(maxSize.height) / height)
			let newWidth = (width * scale)
			size = CGSize(width: newWidth, height: Double(maxSize.height))
		} else {
			let scale = (Double(maxSize.width) / width)
			let newHeight = (height * scale)
			size = CGSize(width: Double(maxSize.width), height: newHeight)
		}

		return size
	}

	func requestImageDataFromDisk(for asset: PHAsset, completion: @escaping (_ imageData: Data?) -> Void) {
		let size = self.downscaledSize(for: asset)
		let options = PHImageRequestOptions()
		options.resizeMode = .exact
		options.deliveryMode = .highQualityFormat
		PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: options) { (image: UIImage?, info: [AnyHashable : Any]?) in
			let data = image?.jpegData(compressionQuality: 1.0)
			completion(data)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
		guard let phAsset = info[UIImagePickerController.InfoKey.phAsset.rawValue] as? PHAsset else {
			if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
				// Otherwise give the image and its date to the handler.
				let imageData = image.jpegData(compressionQuality: 0.8)
				self.completion?(imageData, Date(), nil)
			} else {
				UIAlertController.showErrorMessage("Invalid Image Asset.")
				self.completion?(nil, nil, nil)
			}

			return
		}

		let date = phAsset.creationDate
		let location = phAsset.location
		self.requestImageDataFromDisk(for: phAsset) { [weak self] (imageData: Data?) in
			if let imageData = imageData {
				self?.completion?(imageData, date, location)
			} else {
				UIAlertController.showErrorMessage("Cannot retrieve Image Asset.")
				self?.completion?(nil, date, location)
			}
		}
	}
}

extension ImagePicker: UINavigationControllerDelegate {
	// Required to support the image picker delegate.
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
