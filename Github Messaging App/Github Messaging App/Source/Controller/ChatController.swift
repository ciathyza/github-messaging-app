//
// ChatController.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/10.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation
import CoreData


///
/// Simple delegate used to have ChatViewController loosely coupled to the ChatController
///
protocol ChatControllerDelegate
{
	func onFetchedResultsChanged(type:NSFetchedResultsChangeType, newIndexPath:IndexPath)
	func onDidChangeContent()
}

///
/// Manages the sending an receiving of chat messages.
///
class ChatController : NSObject, NSFetchedResultsControllerDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Constants
	// ----------------------------------------------------------------------------------------------------
	
	private let ENTITY_NAME = "ChatMessage"
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	public var delegate:ChatControllerDelegate?
	
	private lazy var fetchedResultsController:NSFetchedResultsController =
	{
		() -> NSFetchedResultsController<NSFetchRequestResult> in
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		//let delegate = AppDelegate.shared
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		return frc
	}()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	public var currentUserID:String
	{
		get { return AppDelegate.shared.model.currentUser?.login ?? "" }
	}

	
	private var moc:NSManagedObjectContext
	{
		get { return AppDelegate.shared.managedObjectContext }
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	///
	/// Sends a message to the specified user.
	///
	internal func sendMessageTo(userID:String?, text:String)
	{
		if let userID = userID
		{
			storeChatMessage(userID, text, true)
			echoMessageFrom(userID: userID, text: text)
		}
	}
	
	
	///
	/// Receives a message from the specified user.
	///
	internal func receiveMessageFrom(userID:String?, text:String)
	{
		if let userID = userID
		{
			storeChatMessage(userID, text, false)
		}
	}
	

	///
	/// Echos a message two times.
	///
	internal func echoMessageFrom(userID:String?, text:String)
	{
		receiveMessageFrom(userID: userID, text: "\(text) \(text)")
	}
	

	///
	/// Returns message count for current fetch.
	///
	internal func getMessageCount() -> Int
	{
		return fetchedResultsController.sections?[0].numberOfObjects ?? 0
	}
	
	
	///
	/// Returns the chat message at the specified index path.
	///
	internal func getMessageAtIndexPath(indexPath:IndexPath) -> ChatMessage?
	{
		return fetchedResultsController.object(at: indexPath) as? ChatMessage
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Persistent Data Management
	// ----------------------------------------------------------------------------------------------------

	///
	/// Loads all chat messages associated with the currently set user.
	///
	func loadMessagesForCurrentUser()
	{
		do
		{
			fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "userID == %@", self.currentUserID)
			try fetchedResultsController.performFetch()
			Log.debug("APP", "Fetched \(fetchedResultsController.sections?[0].numberOfObjects ?? 0) messages.")
		}
		catch let error
		{
			Log.error("APP", "Error performing fetch: \(error.localizedDescription).")
		}
	}
	
	
	func storeChatMessage(_ userID:String, _ text:String, _ isSender:Bool)
	{
		let message = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: moc) as! ChatMessage
		message.text = text
		message.date = NSDate()
		message.userID = userID
		message.isSender = isSender
		
		do
		{
			try moc.save()
		}
		catch let error
		{
			Log.error("APP", "Error storing data: \(error.localizedDescription).")
			return
		}
		Log.debug("APP", "Chat message stored.")
	}
	
	
	func clearChatMessages()
	{
		do
		{
			let entityNames = [ENTITY_NAME]
			for entityName in entityNames
			{
				let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
				let objects = try (moc.fetch(fetchRequest)) as? [NSManagedObject]
				for object in objects!
				{
					moc.delete(object)
				}
			}
			try (moc.save())
		}
		catch let error
		{
			Log.error("APP", "Error deleting data: \(error.localizedDescription).")
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - NSFetchedResultsControllerDelegate
	// ----------------------------------------------------------------------------------------------------
	
	func controller(_ controller:NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:Any, at indexPath:IndexPath?, for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?)
	{
		if let delegate = delegate
		{
			delegate.onFetchedResultsChanged(type: type, newIndexPath: newIndexPath!)
		}
	}
	
	
	func controllerDidChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>)
	{
		if let delegate = delegate
		{
			delegate.onDidChangeContent()
		}
	}
}
