//
//  JSONDecoder+Extensions.swift
//  DataStack
//
//  Created by Caio on 6/27/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

extension JSONDecoder {
    public convenience init(dateFormat: String? = nil, context: NSManagedObjectContext? = nil) {
        self.init()

        if let dateFormat = dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.isLenient = true
            dateFormatter.dateFormat = dateFormat
            dateDecodingStrategy = .formatted(dateFormatter)
        }

        if let context = context {
            userInfo[CodingUserInfoKey.managedObjectContext] = context
        }
    }

    public func managedObjectContext() -> NSManagedObjectContext? {
        return userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext
    }
}
