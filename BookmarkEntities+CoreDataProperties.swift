//
//  BookmarkEntities+CoreDataProperties.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/11/12.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BookmarkEntities {

    @NSManaged var author: String?
    @NSManaged var autoIncrement: NSNumber?
    @NSManaged var body: String?
    @NSManaged var division: String?
    @NSManaged var id: String?
    @NSManaged var photoUIImage: NSData?
    @NSManaged var time: String?
    @NSManaged var title: String?
    @NSManaged var imageIsDefault: NSNumber?

}
