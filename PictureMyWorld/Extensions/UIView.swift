//
//  UIView.swift
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

extension UIView {

	func roundRect(radius: CGFloat) {
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
	}

	func addSubview(safe view: UIView?) {
		guard let view = view else {
			return
		}

		self.addSubview(view)
	}

	func bringSubviewToFront(safe view: UIView?) {
		guard let view = view else {
			return
		}

		self.bringSubviewToFront(view)
	}
}
