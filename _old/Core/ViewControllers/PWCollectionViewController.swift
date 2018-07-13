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
import Reachability

class PWCollectionViewController				: UICollectionViewController {

	private var inputSources					= [AssetManagerSource]()
	private var refreshControl					= UIRefreshControl()
	private var posts							= [Post]() {
		didSet {
			self.setupInputSources()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = L("FULL_TITLE")
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.themeColor()]
		self.navigationController?.navigationBar.tintColor = UIColor.themeColor()

		self.refreshControl.addTarget(self, action: #selector(self.didPullToRefresh), forControlEvents: .ValueChanged)
		self.collectionView?.addSubview(self.refreshControl)
		self.collectionView?.collectionViewLayout = CollectionViewWaterfallLayout()

		self.posts = Post.allEntities()
		self.setupWaterfallLayout()
		self.refreshContent()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Analytics.sendScreenView(.CollectionView)
	}

	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition(nil, completion: { (context: UIViewControllerTransitionCoordinatorContext) in
			Analytics.UserAction.DidChangeDeviceOrientation
			self.setupWaterfallLayout(size)
		})
	}

	@IBAction func helpButtonPressed() {
		if let controller = self.storyboard?.instantiateViewControllerWithIdentifier(ReusableIdentifier.InfoViewController) as? PWInfoViewController {
			self.navigationController?.addChildViewController(controller)
			controller.view.frame = self.view.frame
			self.navigationController?.view.addSubview(controller.view)
			controller.didMoveToParentViewController(self)
			controller.toggleState()
		}
	}
}

// MARK: - Data Management

extension PWCollectionViewController {

	func didPullToRefresh() {
		Analytics.UserAction.DidPullToRefresh.send()
		self.refreshContent(didPullToRefresh: true)
	}

	private func refreshContent(didPullToRefresh pullToRefresh: Bool = false) {
		guard (Reachability.isConnected == true) else {
			self.showNoInternetAlert(didPullToRefresh: pullToRefresh)
			self.refreshControl.endRefreshing()
			return
		}

		let baseURL = NSBundle.stringEntryInPListForKey(PWPlist.APIBaseURL)
		if let html = HTMLParser.fetchHTML(fromString: baseURL) {
			let postsArray = HTMLParser.parse(html)
			DKDBManager.crudPosts(postsArray, completionBlock: {
				self.posts = Post.allEntities()
				self.setupWaterfallLayout()
				self.collectionView?.reloadData()
				self.refreshControl.endRefreshing()
			})
		}
	}

	private func showNoInternetAlert(didPullToRefresh pullToRefresh: Bool) {
		if (Reachability.isConnected == true || (Post.count() != 0 && pullToRefresh == false)) {
			return
		}
		let alert = UIAlertController(title: "", message: L("NO_INTERNET_CONNECTION"), preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: L("POPUP_OK"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
			self.performBlockAfterDelay(1, block: { [weak self] in
				self?.refreshContent()
			})
		}))
		self.presentViewController(alert, animated: true, completion: {
			Analytics.UserAction.DidLoadWithoutInternet.send()
		})
	}
}

// MARK: - ImageSlideshow

extension PWCollectionViewController {

	private func setupInputSources() {
		self.inputSources = self.posts.flatMap { (post: Post) -> AssetManagerSource? in
			guard let
				imageURLString = post.imageURL,
				thumbnailURLString = post.thumbnailURL else {
					return nil
			}
			return AssetManagerSource(imageURLString: imageURLString, thumbnailURLString: thumbnailURLString)
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
		Analytics.UserAction.DidSelectItemCell.send()
		self.openSlideShowController(indexPath.item)
	}
}

// MARK: - UIScrollViewDelegate

extension PWCollectionViewController {

	override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		Analytics.UserAction.DidScrollCollectionView.send()
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

	private func setupWaterfallLayout(size: CGSize? = nil) {
		guard let layout = self.collectionView?.collectionViewLayout as? CollectionViewWaterfallLayout else {
			return
		}
		layout.columnCount = Int(self.numberOfItemsPerRow(size))
		layout.minimumColumnSpacing = Float(Interface.CollectionView.Inset)
		layout.minimumInteritemSpacing = Float(Interface.CollectionView.Inset)
		let visibleItems = (self.collectionView?.indexPathsForVisibleItems() ?? [])
		layout.invalidateLayout()
		if let indexPath = visibleItems.last {
			self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
		}
	}

	func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

		guard let post = self.posts[safe: indexPath.item] else {
			return CGSize.zero
		}

		// Calculate the exact minimum size per item to fill the view.
		// Width
		let separatorsWidth = ((self.numberOfItemsPerRow() * Interface.CollectionView.Inset) * 0.5)
		let width = ((self.currentWidthAvailable() - separatorsWidth) / self.numberOfItemsPerRow())
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

	/**
	Calculate the with available for the items between the two left and right margins.

	- parameter size: In case of device roatation, the new size for the container’s view.

	- returns: The width available in CGFloat for the items in the colleciton view cell.
	*/
	private func currentWidthAvailable(size: CGSize? = nil) -> CGFloat {

		let edgeSpacing = (Interface.CollectionView.Inset * 2)

		if let size = size {
			return (size.width - edgeSpacing)
		}

		if let collectionView = self.collectionView {
			return (collectionView.bounds.size.width - edgeSpacing)
		}

		return 0
	}

	/**
	Calculate the number of item that can be displayed per row.

	- parameter size: In case of device roatation, the new size for the container’s view.

	- returns: The number of item.
	*/
	private func numberOfItemsPerRow(size: CGSize? = nil) -> CGFloat {
		var numberOfItemPerRow : CGFloat = 0.0
		repeat {
			numberOfItemPerRow += 1.0
		} while ((self.currentWidthAvailable(size) / (numberOfItemPerRow + 1.0)) > Interface.CollectionView.MinimumItemWidth)
		return numberOfItemPerRow
	}
}