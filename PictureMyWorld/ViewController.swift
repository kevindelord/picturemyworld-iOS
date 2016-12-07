//
//  ViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let html = HTMLParser.fetchHTML(fromString: API.BaseURL) {
			let data = HTMLParser.parse(html)
			print("Posts to create: \(data.count)")
		}
	}
}
