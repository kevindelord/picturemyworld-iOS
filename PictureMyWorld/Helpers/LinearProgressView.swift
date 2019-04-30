//
//  LinearProgressView.swift
//
//  Created by Kevin Delord on 18.08.17.
//  Copyright © Kevin Delord. All rights reserved.
//
//  Code inspired from: https://github.com/lfarah/LinearProgressBar
//

import Foundation
import UIKit

/// Protocol integrating the `progressView` attribute and related in/out functions.
protocol ProgressView {

	/// Computed property of an optional HAProgressView UI element.
	var progressView : LinearProgressView? { get }

	/// Start the animation on the related computed progress view.
	func showProgressView()

	/// Stop the animation on the related computed progress view.
	func hideProgressView()
}

// MARK: - Protocol Extension

extension ProgressView {

	/// Show and animate the progress view.
	func showProgressView() {
		DispatchQueue.main.async {
			self.progressView?.startAnimation()
		}
	}

	/// Hide Progress View.
	func hideProgressView() {
		DispatchQueue.main.async {
			self.progressView?.stopAnimation()
		}
	}
}

// MARK: - Interface Constants

struct Interface {

	struct ProgressView {

		static let standard					= CGFloat(4.0)
		static let reducedSizeRatio			= CGFloat(0.6)
		static let slidedOriginRatio		= CGFloat(0.3)
		static let firstSlideDuration		= TimeInterval(0.7)
		static let secondSlideDuration		= TimeInterval(0.7)
		static let secondSlideDelay			= TimeInterval(0.5)
		static let inBetweenInterval		= TimeInterval(0.3)
		static let lockQueueIdentifier		= "io.kevindelord.progressview"
	}
}

// MARK: - ProgressView UI element

/// UIKit object representing an indeterminate progress view.
public class LinearProgressView				: UIView {

	fileprivate var progressBarIndicator	: UIView?
	fileprivate var widthForLinearBar		: CGFloat = 0

	fileprivate var progressBarColor 		: UIColor {
		return self.tintColor
	}

	fileprivate var isAnimationRunning		= false {
		didSet {
			// Toggle the activity indicator in the status bar.
			UIApplication.shared.isNetworkActivityIndicatorVisible = self.isAnimationRunning
		}
	}

	// Lock Queue to avoid multi-threading problem for the anitmation.
	fileprivate let lockQueue = DispatchQueue(label: Interface.ProgressView.lockQueueIdentifier)

	convenience public init?(within superView: UIView?, layoutSupport: UILayoutSupport) {
		guard let superView = superView else {
			return nil
		}

		self.init(frame: CGRect(x: 0, y: 0, width: superView.frame.width, height: Interface.ProgressView.standard))

		self.initViewPosition(within: superView, layoutSupport: layoutSupport)
		self.initProgressBarIndicator()
	}

	override private init(frame: CGRect) {
		// Override required to activate/enable the convenience init.
		super.init(frame: frame)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("Storyboard not supported")
	}

	/// Configure the current view into its superview.
	///
	/// - Parameters:
	///   - superView: Superview owning the current ProgressView.
	///   - layoutSupport: Bottom or Top Layout Support (for the navigation bar).
	///   - position: Position of the progress view within the superview (bottom or top).
	private func initViewPosition(within superView: UIView, layoutSupport: UILayoutSupport) {
		superView.addSubview(self)
		superView.bringSubviewToFront(safe: self)

		self.backgroundColor = UIColor.clear
		self.translatesAutoresizingMaskIntoConstraints = false
		let height = Interface.ProgressView.standard

		// Height
		NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height).isActive = true
		// X origin
		NSLayoutConstraint.equal(.leading, view: self, superview: superView)
		// Width
		NSLayoutConstraint.equal(.trailing, view: self, superview: superView)
		// Y origin
		NSLayoutConstraint.equal(.top, view: self, superview: layoutSupport, secondAttribute: .bottom)
	}

	/// Configure the indicator bar.
	private func initProgressBarIndicator() {
		self.progressBarIndicator = UIView(frame: CGRect.zero)
		self.progressBarIndicator?.backgroundColor = self.progressBarColor
		self.progressBarIndicator?.roundRect(radius: 2)
		self.addSubview(safe: self.progressBarIndicator)

		guard let subview = self.progressBarIndicator else {
			return
		}

		subview.translatesAutoresizingMaskIntoConstraints = false
		// X, Height
		NSLayoutConstraint.equal(.top, view: subview, superview: self)
		NSLayoutConstraint.equal(.bottom, view: subview, superview: self)
	}
}

// MARK: - Animation functions

extension LinearProgressView {

	/// Start the animation
	public func startAnimation() {
		self.lockQueue.sync {
			guard (self.isAnimationRunning == false) else {
				return
			}

			self.isAnimationRunning = true
			DispatchQueue.main.async {
				self.configureAnimation()
			}
		}
	}

	/// Stop the animation
	public func stopAnimation() {
		self.lockQueue.sync {
			self.isAnimationRunning = false
		}
	}

	/// Configure and animate the UI elements.
	private func configureAnimation() {
		/// Bring (again) the progress view to the front.
		self.superview?.bringSubviewToFront(safe: self)
		// (Re)configure the bar indicator.
		self.progressBarIndicator?.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height)
		let reduceSize = (self.frame.size.width * Interface.ProgressView.reducedSizeRatio)

		// First step animation
		UIView.animate(withDuration: Interface.ProgressView.firstSlideDuration, delay: 0, options: [], animations: {
			self.progressBarIndicator?.frame = CGRect(x: self.frame.size.width * Interface.ProgressView.slidedOriginRatio,
													  y: 0,
													  width: reduceSize,
													  height: self.frame.size.height)
		}, completion: nil)

		// Second step animation
		UIView.animate(withDuration: Interface.ProgressView.secondSlideDuration, delay: Interface.ProgressView.secondSlideDelay, options: [], animations: {
			self.progressBarIndicator?.frame = CGRect(x: self.frame.width, y: 0, width: reduceSize, height: self.frame.size.height)
		}, completion: { (animationFinished: Bool) in
			self.lockQueue.sync {
				if (self.isAnimationRunning == true) {
					DispatchQueue.main.asyncAfter(deadline: .now() + Interface.ProgressView.inBetweenInterval) { [weak self] in
						self?.configureAnimation()
					}
				}
			}
		})
	}
}
