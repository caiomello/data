//
//  DataStack.swift
//  DataStack
//
//  Created by Caio Mello on August 17, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

public struct DataStack {
	private let model: String

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: model)

		container.loadPersistentStores(completionHandler: { (description, error) in
			if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }

            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		})

		return container
	}()

    public private(set) lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext

	public func save(_ context: NSManagedObjectContext) {
		if context.hasChanges {
			do {
				try context.save()
                print("Context saved: \(context)")
			} catch {
				print("Failed to save to persistent store: \(error)")
			}
		}
	}
}
