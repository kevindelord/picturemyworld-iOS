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

	func update(with country: Country?) {
		guard let country = country else {
			return
		}

		self.name?.text = country.name
		self.filename?.text = country.filename
	}
}
