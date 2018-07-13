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

class PWInfoViewController								: UIViewController {

	@IBOutlet private weak var containerView 			: UIView?
	@IBOutlet private weak var versionLabel 			: UILabel?
	@IBOutlet private weak var aboutLabel 				: UILabel?
	@IBOutlet private weak var aboutTextLabel			: UILabel?
	@IBOutlet private weak var buglifeDescriptionLabel 	: UILabel?
	@IBOutlet private weak var buglifeTitleLabel 		: UILabel?
	@IBOutlet private weak var madeByLabel				: UILabel?

	override func viewDidLoad() {
		super.viewDidLoad()

		// View setup
		self.containerView?.roundRect(radius: 10)
		self.containerView?.alpha = 0

		// Text
		self.versionLabel?.text 			= appVersion()
		let url = NSBundle.stringEntryInPListForKey(PWPlist.APIBaseURL)
		self.aboutTextLabel?.text 			= String(format: L("INFO_ABOUT_TEXT"), url)
		self.aboutLabel?.text				= L("INFO_ABOUT_TITLE")
		self.buglifeTitleLabel?.text 		= L("INFO_BUG_TITLE")
		self.buglifeDescriptionLabel?.text 	= L("INFO_BUG_TEXT")
		self.madeByLabel?.text 				= L("INFO_MADE_BY")

		// Hide action
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleState))
		tapRecognizer.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tapRecognizer)
	}

	func toggleState() {
		if (self.containerView?.alpha == 0.0) {
			UIView.animateWithDuration(0.3, animations: {
				self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
				self.containerView?.alpha = 1
			}, completion: { (didFinish: Bool) in
				Analytics.UserAction.DidOpenInfoView.send()
			})
		} else {
			UIView.animateWithDuration(0.3, animations: {
				self.view.backgroundColor = UIColor.clearColor()
				self.containerView?.alpha = 0
			}, completion: { [weak self] (didFinish: Bool) in
				self?.willMoveToParentViewController(nil)
				self?.view.removeFromSuperview()
				self?.removeFromParentViewController()
				Analytics.UserAction.DidCloseInfoView.send()
			})
		}
	}
}
