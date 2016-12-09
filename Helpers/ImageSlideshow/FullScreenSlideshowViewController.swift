//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 31.08.15.
// 	Updated by Kevin Delord on 09.12.16
//  Code base updated from version: 0.6.0
// 	URL: https://github.com/zvonicek/ImageSlideshow
//

import UIKit

public class FullScreenSlideshowViewController	: UIViewController {
    
    public var slideshow						: ImageSlideshow = {
        let slideshow 				= ImageSlideshow()
        slideshow.zoomEnabled 		= true
        slideshow.contentScaleMode 	= UIViewContentMode.ScaleAspectFit
        slideshow.autoresizingMask 	= [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        return slideshow
    }()
    
    public var closeButton 						= UIButton()
    public var slideshowDidClose				: ((onPageIndex: Int) -> ())?
    
    /// Index of initial image
    public var initialImageIndex				: Int = 0
    public var inputs							: [InputSource]?
    
    /// Background color
    public var backgroundColor 					= UIColor.blackColor()
    
    /// Enables/disable zoom
    public var zoomEnabled 						= true {
        didSet {
            self.slideshow.zoomEnabled = self.zoomEnabled
        }
    }
    
    private var isInit 							= true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        
        // slideshow view configuration
        self.slideshow.frame = self.view.frame
        self.slideshow.backgroundColor = self.backgroundColor
        
        if let inputs = self.inputs {
            self.slideshow.setImageInputs(inputs)
        }
        
        self.slideshow.frame = view.frame
        self.view.addSubview(self.slideshow);
        
        // close button configuration
        self.closeButton.frame = CGRectMake(10, 20, 40, 40)
        self.closeButton.setImage(UIImage(named: "ic_cross_white"), forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.closeButton)

		self.setupTapRecognizers()
    }

    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.isInit == true) {
            self.isInit = false
            self.slideshow.setScrollViewPage(self.initialImageIndex, animated: false)
        }
    }
    
    func close() {
        // if pageSelected closure set, send call it with current page
		self.slideshowDidClose?(onPageIndex: self.slideshow.scrollViewPage)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Tap Recognizers

extension FullScreenSlideshowViewController {

	private func setupTapRecognizers() {
		// Hide close button
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FullScreenSlideshowViewController.toggleCloseButton))
		tapRecognizer.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tapRecognizer)

		// Zoom
		let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FullScreenSlideshowViewController.tapZoom))
		doubleTapRecognizer.numberOfTapsRequired = 2
		self.view.addGestureRecognizer(doubleTapRecognizer)

		// Fix conflict
		tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
	}

	func tapZoom() {
		self.slideshow.currentSlideshowItem?.tapZoom()
	}

	func toggleCloseButton() {
		self.closeButton.hidden = (self.closeButton.hidden == false)
	}
}
