//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Mansur Ahmed on 2020-05-07.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    var wrappedName: String {
        name ?? "Unknown Candy"
    }
}
