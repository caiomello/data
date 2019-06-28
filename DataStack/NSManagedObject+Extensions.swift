//
//  NSManagedObject+Extensions.swift
//  DataStack
//
//  Created by Caio on 6/27/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public class func fetch<T: NSManagedObject>(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entity().name!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to execute fetch request: \(error)")
            return []
        }
    }
}
