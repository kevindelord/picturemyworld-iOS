//
//  ViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import UIKit
import DKDBManager
import DKHelper
import CollectionViewWaterfallLayoutSH

class PWCollectionViewController		: UICollectionViewController {

	private var posts					= [Post]() {
		didSet {
			self.setupInputSources()
		}
	}
	private var inputSources			= [AssetManagerSource]()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = L("FULL_TITLE")
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.themeColor()]

		self.posts = Post.allEntities()
		self.setupWaterfallLayout()
		self.reloadButtonPressed()
	}

	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition(nil, completion: { (context: UIViewControllerTransitionCoordinatorContext) in
			self.setupWaterfallLayout()
		})
	}
}

// MARK: - IBAction

extension PWCollectionViewController {

	@IBAction func reloadButtonPressed() {
		if let html = HTMLParser.fetchHTML(fromString: API.BaseURL) {
			let postsArray = HTMLParser.parse(html)
			DKDBManager.crudPosts(postsArray, completionBlock: {
				self.posts = Post.allEntities()
				self.setupWaterfallLayout()
				self.collectionView?.reloadData()
			})
		}
	}
}

// MARK: - ImageSlideshow

extension PWCollectionViewController {

	private func setupInputSources() {
		self.inputSources = self.posts.flatMap { (post: Post) -> AssetManagerSource? in
			guard let urlString = post.imageURL else {
				return nil
			}
			return AssetManagerSource(urlString: urlString)
		}
	}

	private func openSlideShowController(initialImageIndex: Int) {

		let ctr = FullScreenSlideshowViewController()
		ctr.initialImageIndex = initialImageIndex
		ctr.inputs = self.inputSources
		ctr.slideshow.zoomEnabled = true
		ctr.slideshowDidClose = { (onPageIndex: Int) in
			let indexPath = NSIndexPath(forItem: onPageIndex, inSection: 0)
			self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
		}

		self.presentViewController(ctr, animated: true, completion: nil)
	}
}

// MARK: - UICollectionViewDelegate

extension PWCollectionViewController {

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		self.openSlideShowController(indexPath.item)
	}
}

// MARK: - UICollectionViewDataSource

extension PWCollectionViewController {

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.posts.count
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReusableIdentifier.PostCollectionViewCell, forIndexPath: indexPath) as? PWPostCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.updateWithPost(self.posts[safe: indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PWCollectionViewController: CollectionViewWaterfallLayoutDelegate {

	private func setupWaterfallLayout() {
		guard let layout = self.collectionView?.collectionViewLayout as? CollectionViewWaterfallLayout else {
			return
		}
		layout.columnCount = Int(self.numberOfItemsPerRow)
		layout.minimumColumnSpacing = Float(Interface.CollectionView.Inset)
		layout.minimumInteritemSpacing = Float(Interface.CollectionView.Inset)
		layout.invalidateLayout()
	}

	func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

		guard let post = self.posts[safe: indexPath.item] else {
			return CGSize.zero
		}

		// Calculate the exact minimum size per item to fill the view.
		// Width
		let separatorsWidth = ((self.numberOfItemsPerRow * Interface.CollectionView.Inset) * 0.5)
		let width = ((self.currentWidthAvailable - separatorsWidth) / self.numberOfItemsPerRow)
		// Height
		let imageHeight = (width * post.validThumbnailRatio)
		let descriptionHeight = PWPostCollectionViewCell.descriptionTextHeight(post.descriptionText, forSizeWidth: width)
		let height = imageHeight + descriptionHeight + Interface.CollectionView.MinComposentItemHeight
		return CGSize(width: width, height: height)
	}

	func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets {
		let padding = Interface.CollectionView.Inset
		return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
	}

	/// Calculate the available with in between the two left and right margins.
	private var currentWidthAvailable: CGFloat {
		guard let collectionView = self.collectionView else {
			return 0
		}
		let edgeSpacing = Interface.CollectionView.Inset
		let widthAvailable = (collectionView.bounds.size.width - (edgeSpacing * 2))
		return widthAvailable
	}

	/// Calculate the number of item available until the minimum width of the displayed item.
	private var numberOfItemsPerRow: CGFloat {
		var numberOfItemPerRow : CGFloat = 0.0
		repeat {
			numberOfItemPerRow += 1.0
		} while ((self.currentWidthAvailable / (numberOfItemPerRow + 1.0)) > Interface.CollectionView.MinimumItemWidth)
		return numberOfItemPerRow
	}
}
