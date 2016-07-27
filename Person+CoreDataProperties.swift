//
//  Person+CoreDataProperties.swift
//  MealTime
//
//  Created by Игорь Михайлович Ракитянский on 27.07.16.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var name: String?
    @NSManaged var meals: NSOrderedSet?

}
