//
//  JSONDecoder+Extensions.swift
//  Services
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
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.isLenient = true
            dateDecodingStrategy = .formatted(formatter)
        }

        if let context = context {
            userInfo[CodingUserInfoKey.managedObjectContext] = context
        }
    }

    public func managedObjectContext() -> NSManagedObjectContext? {
        return userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext
    }
}
