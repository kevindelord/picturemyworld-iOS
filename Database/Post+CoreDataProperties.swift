//
//  Post+CoreDataProperties.swift
//  PictureMyWorld
//
//  Created by Kevin Delord on 08/12/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  To delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var date: NSDate?
    @NSManaged var dateString: String?
    @NSManaged var descriptionText: String?
    @NSManaged var identifier: String?
    @NSManaged var imageURL: String?
    @NSManaged var mapsLink: String?
    @NSManaged var mapsText: String?
    @NSManaged var thumbnailURL: String?
    @NSManaged var title: String?
    @NSManaged var thumbnailRatio: NSNumber?

}
