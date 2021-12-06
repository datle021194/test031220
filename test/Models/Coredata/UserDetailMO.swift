//
//  UserDetailMO.swift
//  
//
//  Created by Admin on 05/12/2021.
//
//

import Foundation
import CoreData


class UserDetailMO: NSManagedObject {
    override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetail")
    }
    
    @NSManaged var login: String?
    @NSManaged var avatarURL: String?
    @NSManaged var bio: String?
    @NSManaged var followers: Int64
    @NSManaged var following: Int64
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var publicRepos: Int64
}
