//
//  ContentTypeSegmentedControl.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class ContentTypeSegmentedControl : UISegmentedControl {

	override func awakeFromNib() {
		super.awakeFromNib()

		self.removeAllSegments()
		for type in ContentType.allCases {
			self.insertSegment(withTitle: type.title, at: type.rawValue, animated: false)
		}

		self.selectedSegmentIndex = ContentType.defaultType.rawValue
	}
}
