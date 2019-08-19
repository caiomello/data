//
//  Decoder+Extensions.swift
//  Services
//
//  Created by Caio on 6/18/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Decoder {
    public func managedObjectContext() -> NSManagedObjectContext? {
        return userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext
    }
}
