//
//  AppDelegate.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/06.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	var window:UIWindow?
	var model = Model()
	lazy var chatController = ChatController()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool
	{
		return true
	}
	
	
	func applicationWillResignActive(_ application:UIApplication)
	{
	}
	
	
	func applicationDidEnterBackground(_ application:UIApplication)
	{
	}
	
	
	func applicationWillEnterForeground(_ application:UIApplication)
	{
	}
	
	
	func applicationDidBecomeActive(_ application:UIApplication)
	{
	}
	
	
	func applicationWillTerminate(_ application:UIApplication)
	{
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Core Data stack
	// ----------------------------------------------------------------------------------------------------
	
	lazy var applicationDocumentsDirectory:URL =
	{
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[urls.count - 1]
	}()
	
	lazy var managedObjectModel:NSManagedObjectModel =
	{
		let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	lazy var persistentContainer:NSPersistentContainer =
	{
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores(completionHandler:
		{
			(storeDescription, error) in
			if let error = error as NSError?
			{
				Log.fatal("APP", "Unresolved error: \(error), \(error.userInfo).")
			}
		})
		return container
	}()
	
	lazy var persistentStoreCoordinator:NSPersistentStoreCoordinator =
	{
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
		var failureReason = "There was an error creating or loading the application's saved data."
		do
		{
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
		}
		catch
		{
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
			dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
			dict[NSUnderlyingErrorKey] = error as NSError
			let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
			Log.error("APP", "Unresolved error: \(wrappedError), \(wrappedError.userInfo).")
			abort()
		}
		return coordinator
	}()
	
	lazy var managedObjectContext:NSManagedObjectContext =
	{
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Core Data Saving support
	// ----------------------------------------------------------------------------------------------------
	
	func saveContext()
	{
		let context = persistentContainer.viewContext
		if context.hasChanges
		{
			do
			{
				try context.save()
			}
			catch
			{
				let nserror = error as NSError
				Log.fatal("APP", "Unresolved error: \(nserror), \(nserror.userInfo).")
			}
		}
	}
}
