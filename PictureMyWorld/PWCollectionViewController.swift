//
//  ViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import UIKit
import DKDBManager

class PWCollectionViewController	: UICollectionViewController {

	private var posts				= [Post]()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Picture My World"
		self.posts = (Post.all() as? [Post] ?? [])
		self.reloadButtonPressed()
	}

	@IBAction func reloadButtonPressed() {
		if let html = HTMLParser.fetchHTML(fromString: API.BaseURL) {
			let postsArray = HTMLParser.parse(html)
			DKDBManager.crudPosts(postsArray, completionBlock: {
				self.posts = (Post.all() as? [Post] ?? [])
				self.collectionView?.reloadData()
			})
		}
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

class PWPostCollectionViewCell 					: UICollectionViewCell {

	@IBOutlet private weak var titleLabel 		: UILabel?
	@IBOutlet private weak var locationLabel 	: UILabel?
	@IBOutlet private weak var descriptionLabel	: UILabel?
	@IBOutlet private weak var dateLabel 		: UILabel?
	@IBOutlet private weak var imageView 		: UIImageView?

	var currentThumbnailURL 					: String?

	func updateWithPost(post: Post?) {

		guard let post = post else {
			return
		}

		self.titleLabel?.text = post.title
		self.locationLabel?.text = post.mapsText
		self.descriptionLabel?.text = post.descriptionText
		self.dateLabel?.text = post.dateString
		self.currentThumbnailURL = post.thumbnailURL

		AssetManager.downloadImage(self.currentThumbnailURL, priority: DownloadPriority.High, completion: { [weak self] (image) in
			// Only display the picture if and only if the cell is still waiting for the same image.
			// For example, if the user scrolls fast the cell will be reused many times.
			// Each reuse will start the download of the asset; which will be later displayed and then replaced by the next one.
			// The downloaded (or retrieved) image has its url set as `accessibilityIdentifier`.
			if (image?.accessibilityIdentifier == self?.currentThumbnailURL) {
				self?.performBlockInMainThread {
					self?.imageView?.image = image
				}
			}
		})
	}

	override func prepareForReuse() {
		// Reset the image view and the current thumbnail URL.
		self.imageView?.image = nil
		self.currentThumbnailURL = nil
	}
}
