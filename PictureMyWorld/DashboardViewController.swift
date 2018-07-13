//
//  DashboardViewController.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 13.07.18.
//  Copyright © 2018 Kevin Delord. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print(sender)
		print(segue.destination)
	}
}

extension DashboardViewController {

	@IBAction private func openListView(_ sender: UIButton) {
		self.performSegue(withIdentifier: "openListView", sender: sender)
	}
}
