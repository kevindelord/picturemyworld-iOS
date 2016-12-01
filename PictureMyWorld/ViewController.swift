//
//  ViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let html = self.fetchHTML() {
			self.parseHTML(html)
		}
	}

	private func fetchHTML() -> String? {
		let myURLString = "http://picturemy.world"
		guard let myURL = NSURL(string: myURLString) else {
			print("Error: \(myURLString) doesn't seem to be a valid URL")
			return nil
		}

		do {
			let myHTMLString = try String(contentsOfURL: myURL)
			return myHTMLString

		} catch let error as NSError {
			print("Error: \(error)")
			return nil
		}
	}

	private func parseHTML(html: String) {

		var posts = [[String:String]]()

		if let doc = HTML(html: html, encoding: NSUTF8StringEncoding) {

			// Search for nodes by XPath
			for node in doc.xpath("//section/ul[@class='grid']/li/figure") {

				var post = [String:String]()
				post["thumbnailURL"] = node.xpath("img").first?["src"]
				post["title"] = node.xpath("figcaption/h3").first?.text
				post["googleMapsLink"] = node.xpath("figcaption/a").first?["href"]
				post["googleMapsText"] = node.xpath("figcaption/a").first?.text
				post["dateString"] = node.xpath("figcaption/p[@class='post-date']").first?.text
				post["descriptionText"] = node.xpath("figcaption/p").first?.text

				posts.append(post)
			}
		}

		print(posts)
	}
}
