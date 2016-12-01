//
//  Post+CoreDataProperties.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 01/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var title: String?
    @NSManaged var descriptionText: String?
    @NSManaged var mapsLink: String?
    @NSManaged var mapsText: String?
    @NSManaged var dateString: String?
    @NSManaged var thumbnailURL: String?
    @NSManaged var imageURL: String?

}
