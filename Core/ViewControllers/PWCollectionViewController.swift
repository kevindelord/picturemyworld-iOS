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
