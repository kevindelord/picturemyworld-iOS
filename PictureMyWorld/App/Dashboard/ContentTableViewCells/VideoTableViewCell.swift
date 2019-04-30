//
//  VideoTableViewCell.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

	@IBOutlet private weak var title		: UILabel?
	@IBOutlet private weak var caption		: UILabel?
	@IBOutlet private weak var date			: UILabel?
	@IBOutlet private weak var music		: UILabel?
	@IBOutlet private weak var errorImage 	: UIImageView?

	func update(with video: Video?) {
		guard let video = video else {
			return
		}

		self.errorImage?.isHidden = (video.isInvalid == false)
		self.title?.text = video.title
		self.caption?.text = video.caption
		self.date?.text = video.date
		self.music?.text = video.music
	}
}
