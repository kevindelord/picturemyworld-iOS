//
//  ImagePicker.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class ImagePicker	: UIImagePickerController {

	var completion	: ((UIImage?, Date?, CLPlacemark?) -> Void)?

	convenience init(completion: (@escaping ((UIImage?, Date?, CLPlacemark?) -> Void))) {
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

extension ImagePicker {

	func reverseLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
		let geocoder = CLGeocoder()
		// Look up the location and pass it to the completion handler
		geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			if (error == nil) {
				let firstLocation = placemarks?[0]
				completionHandler(firstLocation)
			} else {
				// An error occurred during geocoding.
				completionHandler(nil)
			}
		})
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
			// If any location, reverse the geocode to determine the area of interest.
			if let location = location {
				self.reverseLocation(location: location) { (placemark: CLPlacemark?) in
					self.completion?(image, date, placemark)
				}
			} else {
				// Otherwise give the image and its date to the handler.
				self.completion?(image, date, nil)
			}
		}

		picker.dismiss(animated: true, completion: nil)
	}
}

extension ImagePicker: UINavigationControllerDelegate {
	// Required to support the image picker delegate.
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
