//
//  InputSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
// 	Updated by Kevin Delord on 09.12.16
//  Code base updated from version: 0.6.0
// 	URL: https://github.com/zvonicek/ImageSlideshow
//

import UIKit

@objc public protocol InputSource {
	func fetchImage(completionBlock: ((image: UIImage?) -> Void))
}
