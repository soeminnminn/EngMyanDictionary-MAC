//
//  UserFavorites.swift
//  engmyan
//
//  Created by Soe Minn Minn on 10/8/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Foundation
import CoreData

class UserFavorites : NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var word: String!
    @NSManaged public var refrenceid: Int64
    @NSManaged public var timestamp: Int64
}
