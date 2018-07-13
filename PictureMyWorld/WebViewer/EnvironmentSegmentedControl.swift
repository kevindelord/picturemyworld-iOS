//
//  EnvironmentSegmentedControl.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class EnvironmentSegmentedControl : UISegmentedControl {

	override func awakeFromNib() {
		super.awakeFromNib()

		self.removeAllSegments()
		for type in Environment.allCases {
			self.insertSegment(withTitle: type.key, at: type.rawValue, animated: false)
		}

		self.selectedSegmentIndex = Environment.current.rawValue
	}
}
