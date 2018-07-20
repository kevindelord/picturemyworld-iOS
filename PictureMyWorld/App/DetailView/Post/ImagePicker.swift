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
		// Do nothing
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.completion?(image)
		}

		picker.dismiss(animated: true, completion: nil)
	}
}

extension ImagePicker: UINavigationControllerDelegate {
	// Required to support the image picker delegate.
}
