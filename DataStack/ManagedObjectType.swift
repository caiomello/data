//
//  ManagedObjectType.swift
//  DataStack
//
//  Created by Caio Mello on August 17, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectType {
	static var entityName: String { get }
}

extension NSManagedObject {
	// Insert
	public class func createNew<T: NSManagedObject>(inContext context: NSManagedObjectContext) -> T where T: ManagedObjectType {
		let entityDescription = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
		return T(entity: entityDescription!, insertInto: context)
	}
	
	// Fetch
	public class func fetchObjects<T: NSManagedObject>(withPredicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> [T] where T: ManagedObjectType {
		let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		
		do {
			return try context.fetch(fetchRequest)
		} catch {
			print("Error executing fetch request: \(error)")
			return []
		}
	}
}
