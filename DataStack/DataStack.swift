//
//  DataStack.swift
//  DataStack
//
//  Created by Caio Mello on August 17, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation
import CoreData

public final class DataStack {
	private let model: String
    private let cloudKitContainer: String

    public init(model: String, cloudKitContainer: String) {
        self.model = model
        self.cloudKitContainer = cloudKitContainer
    }

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentCloudKitContainer(name: model)

        let local = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/files/local.sqlite"))
        local.configuration = "Local"

        let cloud = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/files/cloud.sqlite"))
        cloud.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: cloudKitContainer)
        cloud.configuration = "Cloud"

        container.persistentStoreDescriptions = [local, cloud]

		container.loadPersistentStores(completionHandler: { (description, error) in
			if let error = error {
                fatalError("Data - Failed to load persistent store: \(error)")
            }

            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		})

		return container
	}()

    public private(set) lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext

    public func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
            block(context)
        }
    }

	public func save(_ context: NSManagedObjectContext) {
		if context.hasChanges {
			do {
				try context.save()
                print(context == persistentContainer.viewContext ? "Data - View context saved" : "Data - Background context saved")
			} catch {
				print("Data - Failed to save to persistent store: \(error)")
			}
		}
	}
}
