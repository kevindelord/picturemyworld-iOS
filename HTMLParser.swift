//
//  HTMLParser.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 07/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import Kanna

struct HTMLParser {

	/**
	Fetch and return the HTML from a web URL page.

	- parameter urlString: The URL as string of the page to crawl.

	- returns: The HTML as String.
	*/
	static func fetchHTML(fromString urlString: String) -> String? {
		guard let url = NSURL(string: urlString) else {
			print("Error: \(urlString) doesn't seem to be a valid URL")
			return nil
		}

		do {
			DKLog(Verbose.Manager.HTMLParser, "Fetching posts from: \(urlString)")
			return try String(contentsOfURL: url)

		} catch let error as NSError {
			print("Error: \(error)")
			return nil
		}
	}

	/**
	Parse a HTML representation into an array of dictionaries valid for the database.

	- parameter html: The HTML representation.

	- returns: An array of dictionaries representing all the posts.
	*/
	static func parse(html: String) -> [[String: String]] {

		var posts = [[String: String]]()
		DKLog(Verbose.Manager.HTMLParser, "Parsing HTML...")
		if let doc = HTML(html: html, encoding: NSUTF8StringEncoding) {
			// Search for nodes by XPath
			for node in doc.xpath("//section/ul[@class='grid']/li/figure") {
				if let postData = HTMLParser.generatePostData(node) {
					posts.append(postData)
					break
				}
			}
		}
		DKLog(Verbose.Manager.HTMLParser, "Total of \(posts.count) posts parsed.")
		return posts
	}
}

// MARK: - Generator

private extension HTMLParser {

	private static func generatePostData(node: XMLElement) -> [String: String]? {

		guard let
			thumbnailURL		= node.xpath("img").first?["src"],
			dateString 			= node.xpath("figcaption/p[@class='post-date']").first?.text,
			title 				= node.xpath("figcaption/h3").first?.text,
			descriptionText 	= node.xpath("figcaption/p").first?.text,
			mapsLink		 	= node.xpath("figcaption/a").first?["href"],
			mapsText 			= node.xpath("figcaption/a").first?.text,
			// Generate the missing data required by the local app.
			identifier 			= HTMLParser.generateIdentifier(fromThumbnailURL: thumbnailURL),
			imageURL		 	= HTMLParser.generateImageURL(fromThumbnailURL: thumbnailURL),
			date 				= HTMLParser.generateISODateString(fromDateString: dateString)
			else {
				// If one value is missing, invalid the data and ignore the post
				DKLog(Verbose.Manager.HTMLParser, "Invalid node found: \(node)")
				return nil
		}

		var post = [String: String]()
		// Set valid data that has been fetched.
		post[Database.Key.Post.Title] 			= title
		post[Database.Key.Post.DescriptionText] = descriptionText
		post[Database.Key.Post.MapsLink] 		= mapsLink
		post[Database.Key.Post.MapsText] 		= mapsText
		post[Database.Key.Post.ThumbnailURL] 	= thumbnailURL
		post[Database.Key.Post.DateString] 		= dateString
		post[Database.Key.Post.Identifier] 		= identifier
		post[Database.Key.Post.ImageURL]		= imageURL
		post[Database.Key.Post.Date] 			= date

		return post
	}

	private static func generateImageURL(fromThumbnailURL url: String) -> String? {
		// The thumbnail image is always formed like this: http://picturemy.world//img/thumb/1480443470.jpg
		// And the big slideshow image like: http://picturemy.world//img/large/1480443470.jpg
		// To generate the large image, replace 'thumb' by 'large'
		return url.stringByReplacingOccurrencesOfString(HTMLParser.Key.ImageThumbnail, withString: HTMLParser.Key.ImageLarge)
	}

	private static func generateIdentifier(fromThumbnailURL url: String) -> String? {
		// The thumbnail image is always formed like this: http://picturemy.world//img/thumb/1480443470.jpg
		// As identifier we will use the image file name as it is a timestamp.
		// Careful, sometimes it is a random string and not a real timestamp (number).
		guard let filename = HTMLParser.matchesForRegexInText(HTMLParser.Regex.Filename, text: url).first else {
			return nil
		}
		let identifier = HTMLParser.matchesForRegexInText(HTMLParser.Regex.Identifier, text: filename).first
		return identifier
	}

	private static func generateISODateString(fromDateString dateString: String) -> String? {
		// The displayed date is formatted like this: November 23, 2016
		// We need to extract each value and create a string with that format: 'yyyy-MM-ddT00:00:00Z'
		let formatter = NSDateFormatter()
		formatter.dateFormat = HTMLParser.DateFormat
		formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		guard let validDate = formatter.dateFromString(dateString) else {
			return nil
		}
		return validDate.ISO8601StringValue()
	}
}

private extension HTMLParser {

	private static func matchesForRegexInText(regex: String, text: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let nsString = text as NSString
			let results = regex.matchesInString(text, options: [], range: NSRange(location: 0, length: nsString.length))
			return results.map {
				nsString.substringWithRange($0.range)
			}
		} catch let error as NSError {
			print("ERROR: invalid regex: \(error.localizedDescription)")
			return []
		}
	}
}
