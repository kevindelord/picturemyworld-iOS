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

		let myURLString = "http://picturemy.world"
		guard let myURL = NSURL(string: myURLString) else {
			print("Error: \(myURLString) doesn't seem to be a valid URL")
			return
		}

		do {
			let myHTMLString = try String(contentsOfURL: myURL)
			print("HTML : \(myHTMLString)")
		} catch let error as NSError {
			print("Error: \(error)")
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
