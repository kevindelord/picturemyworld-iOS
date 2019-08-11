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

	func fetchImageData(asset: PHAsset, completion: @escaping (_ imageData: Data?) -> Void) {
		PHImageManager.default().requestImageData(for: asset, options: nil) { (imageData: Data?, dataUTI: String?, orientation: UIImage.Orientation, info: [AnyHashable : Any]?) in
			completion(imageData)
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

		self.fetchImageData(asset: phAsset) { [weak self] (imageData: Data?) in
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
