//
//  Singer+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Mansur Ahmed on 2020-05-07.
//  Copyright © 2020 Mansur Ahmed. All rights reserved.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    
    var wrappedFirstName: String {
        firstName ?? "Unknown First Name"
    }
    
    var wrappedLastName: String {
        lastName ?? "Unknown Last Name"
    }

}
