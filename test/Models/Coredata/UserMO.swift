//
//  UserMO.swift
//  
//
//  Created by Admin on 05/12/2021.
//
//

import Foundation
import CoreData


class UserMO: NSManagedObject {
    override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    }
    
    @NSManaged var avatarURL: String?
    @NSManaged var htmlURL: String?
    @NSManaged var login: String?
}
