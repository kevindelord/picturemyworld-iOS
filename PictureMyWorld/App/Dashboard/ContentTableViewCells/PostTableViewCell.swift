//
//  PostTableViewCell.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

	@IBOutlet private weak var title		: UILabel?
	@IBOutlet private weak var date			: UILabel?
	@IBOutlet private weak var location 	: UILabel?
	@IBOutlet private weak var caption 		: UILabel?

	func update(with post: Post?) {
		guard let post = post else {
			return
		}

		// TODO: If model is invalid display a error icon.

		self.title?.text = post.title
		self.date?.text = post.date
		self.location?.text = post.locationText
		self.caption?.text = post.caption
	}
}