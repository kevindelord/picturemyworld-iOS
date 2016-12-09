//
//  ZoomablePhotoView.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//

import UIKit

public class ImageSlideshowItem		: UIScrollView, UIScrollViewDelegate {
    
    public let imageView 			= UIImageView()
    public let input				: InputSource
	public let inputIndex			: Int
    public var gestureRecognizer	: UITapGestureRecognizer?
    
    public let zoomEnabled			: Bool
    public var zoomInInitially 		= false
    private var lastFrame 			= CGRectZero
    
    // MARK: - Life cycle
    
	init(input: InputSource, index: Int, zoomEnabled: Bool) {
        self.zoomEnabled = zoomEnabled
        self.input = input
        self.inputIndex = index

        super.init(frame: CGRectNull)

        self.imageView.clipsToBounds = true
        self.imageView.userInteractionEnabled = true

		self.loadImage()
        self.setPictoCenter()
        
        // scroll view configuration
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.addSubview(self.imageView)
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = self.calculateMaximumScale()
        
        // tap gesture recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSlideshowItem.tapZoom))
        tapRecognizer.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(tapRecognizer)
        self.gestureRecognizer = tapRecognizer
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        if (self.zoomEnabled == false) {
            self.imageView.frame.size = frame.size;
        } else if (self.isZoomed() == false) {
            self.imageView.frame.size = self.calculatePictureSize()
            self.setPictoCenter()
        }
        
        if (self.isFullScreen() == true) {
            self.clearContentInsets()
        } else {
            self.setPictoCenter()
        }
        
        // if self.frame was changed and zoomInInitially enabled, zoom in
        if (self.lastFrame != self.frame && self.zoomInInitially == true) {
            self.setZoomScale(self.maximumZoomScale, animated: false)
        }
        
        self.lastFrame = self.frame
        
        self.contentSize = self.imageView.frame.size
        self.maximumZoomScale = self.calculateMaximumScale()
    }

	func loadImage() {
		self.input.fetchImage { (image: UIImage?) in
			self.performBlockInMainThread {
				self.imageView.image = image
				self.setPictoCenter()
			}
		}
	}

	func refreshPosition(scrollViewSize size: CGSize) {
		self.frame = CGRectMake(size.width * CGFloat(self.inputIndex), 0, size.width, size.height)
	}

    // MARK: - Image zoom & size
    
    func isZoomed() -> Bool {
        return (self.zoomScale != self.minimumZoomScale)
    }
    
    func zoomOut() {
        self.setZoomScale(self.minimumZoomScale, animated: false)
    }
    
    func tapZoom() {
		let scale = (self.isZoomed() == true ? self.minimumZoomScale : self.maximumZoomScale)
		self.setZoomScale(scale, animated: true)
    }
    
    private func screenSize() -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

    private func calculatePictureSize() -> CGSize {
        if let image = self.imageView.image {
            let picSize = image.size
            let picRatio = (picSize.width / picSize.height)
			let screenSize = self.screenSize()
            let screenRatio = (screenSize.width / screenSize.height)
            
            if (picRatio > screenRatio){
                return CGSize(width: screenSize.width, height: (screenSize.width / picSize.width * picSize.height))
            } else {
                return CGSize(width: (screenSize.height / picSize.height * picSize.width), height: screenSize.height)
            }
        } else {
            return self.screenSize()
        }
    }
    
    private func calculateMaximumScale() -> CGFloat {
        // maximum scale is fixed to 2.0 for now. This may be overriden to perform a more sophisticated computation
        return 2.0
    }
    
    private func setPictoCenter() {
        var intendHorizon = ((self.screenSize().width - self.imageView.frame.width) * 0.5)
        var intendVertical = ((self.screenSize().height - self.imageView.frame.height) * 0.5)
		intendHorizon = max(intendHorizon, 0)
        intendVertical = max(intendVertical, 0)
        self.contentInset = UIEdgeInsets(top: intendVertical, left: intendHorizon, bottom: intendVertical, right: intendHorizon)
    }
    
    private func isFullScreen() -> Bool {
        return ((self.imageView.frame.width >= screenSize().width) && (imageView.frame.height >= screenSize().height))
    }
    
    func clearContentInsets(){
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        self.setPictoCenter()
    }

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return (self.zoomEnabled ? self.imageView : nil)
    }
}
