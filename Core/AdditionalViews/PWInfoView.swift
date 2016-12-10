//
//  PWInfoView.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 10/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import UIKit
import DKHelper

class PWInfoView										: UIView {

	@IBOutlet private weak var containerView 			: UIView?
	@IBOutlet private weak var versionLabel 			: UILabel?
	@IBOutlet private weak var aboutLabel 				: UILabel?
	@IBOutlet private weak var aboutTextLabel			: UILabel?
	@IBOutlet private weak var buglifeDescriptionLabel 	: UILabel?
	@IBOutlet private weak var buglifeTitleLabel 		: UILabel?
	@IBOutlet private weak var madeByLabel				: UILabel?

	override func awakeFromNib() {
		super.awakeFromNib()

		self.containerView?.roundRect(radius: 10)
		self.versionLabel?.text 			= appVersion()
		let url = NSBundle.stringEntryInPListForKey(PWPlist.APIBaseURL)
		self.aboutTextLabel?.text 			= String(format: L("INFO_ABOUT_TEXT"), url)
		self.aboutLabel?.text				= L("INFO_ABOUT_TITLE")
		self.buglifeTitleLabel?.text 		= L("INFO_BUG_TITLE")
		self.buglifeDescriptionLabel?.text 	= L("INFO_BUG_TEXT")
		self.madeByLabel?.text 				= L("INFO_MADE_BY")

		// Hide info view
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleState))
		tapRecognizer.numberOfTapsRequired = 1
		self.addGestureRecognizer(tapRecognizer)
	}

	func toggleState() {
		if (self.alpha == 0.0) {
			UIView.animateWithDuration(0.3, animations: {
				self.alpha = 1
			}, completion: { (didFinish: Bool) in
				Analytics.UserAction.DidOpenInfoView
			})
		} else {
			UIView.animateWithDuration(0.3, animations: {
				self.alpha = 0
			}, completion: { (didFinish: Bool) in
				Analytics.UserAction.DidCloseInfoView.send()
			})
		}
	}
}
