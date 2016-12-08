//
//  ImageSlideshow.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//

import UIKit

public enum PageControlPosition {
    case Hidden
    case InsideScrollView
    case UnderScrollView
    case Custom(padding: CGFloat)
    
    var bottomPadding: CGFloat {
        switch self {
        case .Hidden, .InsideScrollView:
            return 0.0
        case .UnderScrollView:
            return 30.0
        case .Custom(let padding):
            return padding
        }
    }
}

public class ImageSlideshow: UIView, UIScrollViewDelegate {
    
    public let scrollView = UIScrollView()

    // MARK: - State properties

    /// Current item index
    public private(set) var currentItemIndex: Int = 0
    
    /// Currenlty displayed slideshow item
    public var currentSlideshowItem: ImageSlideshowItem? {
		return self.slideshowItems[safe: scrollViewPage]
    }
    
    public private(set) var scrollViewPage: Int = 0
    public private(set) var inputSources = [InputSource]()
    public private(set) var slideshowItems = [ImageSlideshowItem]()
//	private var inputSources = [InputSource]()

    // MARK: - Preferences

    /// Enables/disables user interactions
    public var draggingEnabled = true {
        didSet {
            self.scrollView.userInteractionEnabled = draggingEnabled
        }
    }
    
    /// Enables/disables zoom
    public var zoomEnabled = false

    /// Content mode of each image in the slideshow
    public var contentScaleMode: UIViewContentMode = UIViewContentMode.ScaleAspectFit {
        didSet {
            for view in slideshowItems {
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
        autoresizesSubviews = true
        clipsToBounds = true
        
        // scroll view configuration
        scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 50.0)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = self.autoresizingMask
        addSubview(scrollView)

        self.layoutScrollView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        self.layoutScrollView()

		self.refreshDisplayedImages()
    }
    
    /// updates frame of the scroll view and its inner items
    func layoutScrollView() {
        scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(self.inputSources.count), scrollView.frame.size.height)
        
        for (index, view) in self.slideshowItems.enumerate() {
            if !view.zoomInInitially {
                view.zoomOut()
            }
            view.frame = CGRectMake(scrollView.frame.size.width * CGFloat(index), 0, scrollView.frame.size.width, scrollView.frame.size.height)
        }
        
        setCurrentPage(currentItemIndex, animated: false)
    }
    
    /// reloads scroll view with latest slideshowItems
    func reloadScrollView() {
        for view in self.slideshowItems {
            view.removeFromSuperview()
        }
        self.slideshowItems = []

        for (index, input) in inputSources.enumerate() {
            let item = ImageSlideshowItem(input: input, zoomEnabled: self.zoomEnabled)
            item.imageView.contentMode = self.contentScaleMode
            slideshowItems.append(item)
            scrollView.addSubview(item)
        }

		self.refreshDisplayedImages()
		self.scrollViewPage = 0
    }
    
    // MARK: - Image setting
    
    public func setImageInputs(inputs: [InputSource]) {
        self.inputSources = inputs

        reloadScrollView()
        layoutScrollView()
    }
    
    // MARK: paging methods
    
    public func setCurrentPage(currentPage: Int, animated: Bool) {
        self.setScrollViewPage(currentPage, animated: animated)
    }
    
    public func setScrollViewPage(scrollViewPage: Int, animated: Bool) {
        if (scrollViewPage < self.inputSources.count) {
            self.scrollView.scrollRectToVisible(CGRectMake(scrollView.frame.size.width * CGFloat(scrollViewPage), 0, scrollView.frame.size.width, scrollView.frame.size.height), animated: animated)
            self.setCurrentPageForScrollViewPage(scrollViewPage)
        }
    }

    public func setCurrentPageForScrollViewPage(page: Int) {
        if (scrollViewPage != page) {
            // current page has changed, zoom out this image
            if (slideshowItems.count > scrollViewPage) {
                slideshowItems[scrollViewPage].zoomOut()
            }
        }
        scrollViewPage = page
		currentItemIndex = page
    }

	func refreshDisplayedImages(delta: Int = 1) {
		for (index, item) in slideshowItems.enumerate() {
			if (index >= (currentItemIndex - delta) && index <= (currentItemIndex + delta)) {
				print("Loading: img \(index) - current \(currentItemIndex)")
				item.loadImage()
			} else {
				if (item.imageView.image != nil) {
					print("Reset: img \(index)")
					item.imageView.image = nil
				}
			}
		}
	}

    // MARK: UIScrollViewDelegate

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.setCurrentPageForScrollViewPage(page)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
		self.refreshDisplayedImages()
	}
}