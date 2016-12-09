//
//  InputSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
// 	Updated by Kevin Delord on 09.12.16
//

import UIKit

@objc public protocol InputSource {
	func fetchImage(completionBlock: ((image: UIImage?) -> Void));
}

public class ImageSource: NSObject, InputSource {
    var image: UIImage!
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public init?(imageString: String) {
        if let image = UIImage(named: imageString) {
            self.image = image
            super.init()
        } else {
            // this may be simplified in Swift 2.2, which fixes the failable initializer compiler issues
            super.init()
            return nil
        }
    }

	@objc public func fetchImage(completionBlock: ((image: UIImage?) -> Void)) {
		completionBlock(image: image)
	}
}
