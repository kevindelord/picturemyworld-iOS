//
//  RawRepresentable.swift
//  HockeyApp-iOS
//
//  Created by Kevin Delord on 21.06.18.
//  Copyright © 2018 SMF. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == Int {

	static var allCases: [Self] {
		// Create array to store all found cases
		var cases = [Self]()
		// Use 0 as start index
		var index = 0
		// Try to create a case for every following integer index until no case is created. If no one is created,
		while let rawCase = self.init(rawValue: index) {
			cases.append(rawCase)
			index += 1
		}

		return cases
	}
}
