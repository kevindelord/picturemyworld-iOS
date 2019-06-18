//
//  AssetLocation.swift
//  PictureMyWorld
//
//  Created by kevindelord on 18/06/2019.
//  Copyright © 2019 Kevin Delord. All rights reserved.
//

import CoreLocation

struct AssetLocation {

	static func reverse(location: CLLocation?, completionHandler: @escaping (String?, String?) -> Void) {
		guard let location = location else {
			completionHandler(nil, nil)
			return
		}

		let geocoder = CLGeocoder()
		// Look up the location and pass it to the completion handler
		geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			if (error == nil) {
				let placemark = placemarks?[0]
				completionHandler(placemark?.formattedLocation(), placemark?.country)
			} else {
				// An error occurred during geocoding.
				completionHandler(nil, nil)
			}
		})
	}
}

extension CLPlacemark {

	fileprivate func formattedLocation() -> String {
		let info = [self.name, self.subLocality, self.administrativeArea].compactMap({$0})
		var address = ""
		for attr in info {
			if (address.isEmpty == true) {
				address = attr
			} else {
				address = address + ", " + attr
			}
		}
		return address
	}
}
