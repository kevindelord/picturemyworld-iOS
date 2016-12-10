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
	@IBOutlet private weak var appDescriptionTextView	: UITextView?
	@IBOutlet private weak var buglifeDescriptionLabel 	: UILabel?
	@IBOutlet private weak var buglifeTitleLabel 		: UILabel?
	@IBOutlet private weak var madeByTextView			: UITextView?

	override func awakeFromNib() {
		super.awakeFromNib()

		self.containerView?.roundRect(radius: 15)
		self.versionLabel?.text = appVersion()
		self.aboutLabel?.text = "About Pict My World"
		self.appDescriptionTextView?.text = "Super app, you know life and shit. awesome."
		self.buglifeTitleLabel?.text = "Found a bug?"
		self.buglifeDescriptionLabel?.text = "Shake your device to report a problem!"
		self.madeByTextView?.text = "Made by Kevin Delord"

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
