//
//  CountryTableViewCell.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

	@IBOutlet private weak var name			: UILabel?
	@IBOutlet private weak var filename		: UILabel?
	@IBOutlet private weak var errorImage 	: UIImageView?

	func update(with country: Country?) {
		guard let country = country else {
			return
		}

		self.name?.text = country.title
		self.filename?.text = country.filename
		self.errorImage?.isHidden = (country.isInvalid == false)
	}
}
