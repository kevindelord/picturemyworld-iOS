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

class PWCollectionViewController	: UICollectionViewController {

	private var posts				= [Post]()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = L("FULL_TITLE")
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.themeColor()]

		self.posts = Post.allEntities()
		self.reloadButtonPressed()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		self.collectionView?.collectionViewLayout.invalidateLayout()
	}
}

// MARK: - IBAction

extension PWCollectionViewController {

	@IBAction func reloadButtonPressed() {
		if let html = HTMLParser.fetchHTML(fromString: API.BaseURL) {
			let postsArray = HTMLParser.parse(html)
			DKDBManager.crudPosts(postsArray, completionBlock: {
				self.posts = Post.allEntities()
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

// MARK: - UICollectionViewDelegateFlowLayout

extension PWCollectionViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

		let width = self.calculateItemWidth(collectionView)

		// Apply a ratio to make the final view looks good on every device.
		return CGSize(width: width, height: width * 1.5)
	}

	private func calculateItemWidth(collectionView: UICollectionView) -> Double {

		// Calculate the available with in between the two left and right margins.
		let edgeSpacing = Interface.CollectionView.EdgeSpacing
		let widthAvailable = (Double(collectionView.bounds.size.width) - (edgeSpacing * 2))

		// Calculate the number of item available until the minimum width of the displayed item.
		var numberOfItemPerRow = 0.0
		repeat {
			numberOfItemPerRow += 1.0
		} while ((widthAvailable / (numberOfItemPerRow + 1.0)) > Interface.CollectionView.MinimumCellWidth)

		// Calculate the exact minimum size per item to fill the view.
		let separatorsWidth = ((numberOfItemPerRow * edgeSpacing) * 0.5)
		let width = ((widthAvailable - separatorsWidth) / numberOfItemPerRow)
		return width
	}
}
