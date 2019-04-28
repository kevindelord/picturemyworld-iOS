//
//  ImagePicker.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 20.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ImagePicker	: UIImagePickerController {

	var completion	: ((UIImage?) -> Void)?

	convenience init(completion: (@escaping ((UIImage?) -> Void))) {
		self.init()

		self.allowsEditing = true
		self.sourceType = .photoLibrary
		self.delegate = self
		self.completion = completion
	}
}

extension ImagePicker: UIImagePickerControllerDelegate {

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
		if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
			self.completion?(image)
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
