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

	var completion	: ((UIImage?, Date?, CLLocation?) -> Void)?

	convenience init(completion: (@escaping ((UIImage?, Date?, CLLocation?) -> Void))) {
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

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
		var date : Date? = nil
		var location : CLLocation? = nil

		if let phAsset = info[UIImagePickerController.InfoKey.phAsset.rawValue] as? PHAsset {
			date = phAsset.creationDate
			location = phAsset.location
		}

		if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
			// Otherwise give the image and its date to the handler.
			self.completion?(image, date, location)
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
