//
//  NSLayoutConstraint.swift
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

	/// Add an active constraint where the given attributes are related as `equal` between the given items.
	///
	/// - Parameters:
	///   - attribute: Layout attribute for the first item
	///   - view: First item to be related to the new constraint (usually the subview).
	///   - superview: Second item to be related to the new constraint (usually the superview).
	///   - secondAttribute: Optional second layout attribute; if nil the first layout attribute will be used again.
	class func equal(_ attribute: NSLayoutConstraint.Attribute,
					 view: UIView,
					 superview: Any?,
					 secondAttribute: NSLayoutConstraint.Attribute? = nil) {

		NSLayoutConstraint(item: view,
						   attribute: attribute,
						   relatedBy: .equal,
						   toItem: superview,
						   attribute: (secondAttribute ?? attribute),
						   multiplier: 1,
						   constant: 0).isActive = true
	}
}
