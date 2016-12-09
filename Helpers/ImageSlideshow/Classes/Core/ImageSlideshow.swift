//
//  ImageSlideshow.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//

import UIKit

public class ImageSlideshow						: UIView, UIScrollViewDelegate {
    
    public let scrollView 						= UIScrollView()

    // MARK: - State properties

    public private(set) var currentItemIndex	: Int = 0
    public private(set) var scrollViewPage		: Int = 0
    public private(set) var inputSources 		= [InputSource]()
	public private(set) var slideshowItems 		= [Int: ImageSlideshowItem]()

	/// Currenlty displayed slideshow item
	public var currentSlideshowItem				: ImageSlideshowItem? {
		return self.slideshowItems[self.scrollViewPage]
	}

    // MARK: - Preferences

    /// Enables/disables user interactions
    public var draggingEnabled 					= true {
        didSet {
            self.scrollView.userInteractionEnabled = self.draggingEnabled
        }
    }
    
    /// Enables/disables zoom
    public var zoomEnabled 						= false

    /// Content mode of each image in the slideshow
    public var contentScaleMode	 				= UIViewContentMode.ScaleAspectFit {
        didSet {
            for view in slideshowItems.values {
                view.imageView.contentMode = contentScaleMode
            }
        }
    }

    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.autoresizesSubviews = true
        self.clipsToBounds = true
        
        // scroll view configuration
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 50.0)
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.autoresizingMask = self.autoresizingMask
        self.addSubview(self.scrollView)

        self.layoutScrollView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

		self.refreshDisplayedImages()
    }
    
    /// updates frame of the scroll view and its inner items
    func layoutScrollView() {
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(self.inputSources.count), self.scrollView.frame.size.height)
        
        for (_, view) in self.slideshowItems {
            if (view.zoomInInitially == false) {
                view.zoomOut()
            }
			view.refreshPosition(scrollViewSize: self.scrollView.frame.size)
        }
        
        self.setCurrentPage(self.currentItemIndex, animated: false)
    }
    
    /// reloads scroll view with latest slideshowItems
    private func reloadScrollView() {
        for view in self.slideshowItems.values {
            view.removeFromSuperview()
        }
		self.slideshowItems = [:]

        for (index, _) in self.inputSources.enumerate() {
            self.slideshowItems[index] = nil
        }

		self.scrollViewPage = 0
		self.refreshDisplayedImages()
    }

	func refreshDisplayedImages(shouldLayoutScrollView shouldRefreshLayout: Bool = true) {
		let delta = Interface.Slideshow.PreloadDelta

		for (index, input) in self.inputSources.enumerate() {
			if (index >= (self.currentItemIndex - delta) && index <= (self.currentItemIndex + delta)) {
				if (self.slideshowItems[index] == nil) {
					let item = ImageSlideshowItem(input: input, index: index, zoomEnabled: self.zoomEnabled)
					item.imageView.contentMode = self.contentScaleMode
					item.refreshPosition(scrollViewSize: self.scrollView.frame.size)
					self.slideshowItems[index] = item
					self.scrollView.addSubview(safe: item)
				}
			} else {
				self.slideshowItems[index]?.removeFromSuperview()
				self.slideshowItems[index] = nil
			}
		}
		if (shouldRefreshLayout == true) {
			self.layoutScrollView()
		}
	}
    
    // MARK: - Image setting
    
    public func setImageInputs(inputs: [InputSource]) {
        self.inputSources = inputs
        self.reloadScrollView()
    }
    
    // MARK: - Paging methods
    
    public func setCurrentPage(currentPage: Int, animated: Bool) {
        self.setScrollViewPage(currentPage, animated: animated)
    }
    
    public func setScrollViewPage(scrollViewPage: Int, animated: Bool) {
        if (scrollViewPage < self.inputSources.count) {
			let width = self.scrollView.frame.size.width
			let height = self.scrollView.frame.size.height
            self.scrollView.scrollRectToVisible(CGRectMake(width * CGFloat(scrollViewPage), 0, width, height), animated: animated)
            self.setCurrentPageForScrollViewPage(scrollViewPage)
        }
    }

    public func setCurrentPageForScrollViewPage(page: Int) {
        if (self.scrollViewPage != page) {
            // current page has changed, zoom out this image
            if (self.slideshowItems.count > self.scrollViewPage) {
                self.slideshowItems[self.scrollViewPage]?.zoomOut()
            }
        }
        self.scrollViewPage = page
		self.currentItemIndex = page
    }

    // MARK: UIScrollViewDelegate

    public func scrollViewDidScroll(scrollView: UIScrollView) {
		let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
		self.setCurrentPageForScrollViewPage(page)
		self.refreshDisplayedImages(shouldLayoutScrollView: false)
	}
}
