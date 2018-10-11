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
	func onWillChangeContent()
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
	
	internal static let ENTITY_NAME = "ChatMessage"
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	public var delegate:ChatControllerDelegate?
	
	private var _fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
	
	private var frc:NSFetchedResultsController<NSFetchRequestResult>
	{
		get
		{
			if _fetchedResultsController == nil
			{
				let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatController.ENTITY_NAME)
				fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
				let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
				frc.delegate = self
				_fetchedResultsController = frc
			}
			return _fetchedResultsController!
		}
	}
	
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
	internal func sendMessageTo(userID:String?, text:String, echo:Bool = true)
	{
		if let userID = userID
		{
			Log.debug("APP", "Sending message to \(userID) ...")
			storeChatMessage(userID, text, true)
			
			if echo
			{
				DispatchQueue.main.asyncAfter(deadline: .now() + 1)
				{
					self.echoMessageFrom(userID: userID, text: text)
				}
			}
		}
	}
	
	
	///
	/// Receives a message from the specified user.
	///
	internal func receiveMessageFrom(userID:String?, text:String)
	{
		if let userID = userID
		{
			Log.debug("APP", "Receiving message from \(userID) ...")
			storeChatMessage(userID, text, false)
		}
	}
	

	///
	/// Echos a message two times as a received message.
	///
	internal func echoMessageFrom(userID:String?, text:String)
	{
		receiveMessageFrom(userID: userID, text: "\(text) \(text)")
		Log.debug("APP", "Echoed message from \(userID ?? "nil").")
	}
	

	///
	/// Returns message count for current fetch.
	///
	internal func getMessageCount() -> Int
	{
		return frc.sections?[0].numberOfObjects ?? 0
	}
	
	
	///
	/// Returns the chat message at the specified index path.
	///
	internal func getMessageAtIndexPath(indexPath:IndexPath) -> ChatMessage?
	{
		return frc.object(at: indexPath) as? ChatMessage
	}
	
	
	func isIndexPathValid(_ indexPath:IndexPath) -> Bool
	{
		if let sections = frc.sections, indexPath.section < sections.count
		{
			if indexPath.row < sections[indexPath.section].numberOfObjects
			{
				return true
			}
		}
		return false
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
			frc.fetchRequest.predicate = NSPredicate(format: "userID = %@", currentUserID)
			try frc.performFetch()
			Log.debug("APP", "Loaded \(frc.sections![0].numberOfObjects) messages for user \(currentUserID) ...")
		}
		catch let error
		{
			Log.error("APP", "Error performing fetch: \(error.localizedDescription).")
		}
	}
	
	
	///
	/// Stores a new chat message persistently.
	///
	func storeChatMessage(_ userID:String, _ text:String, _ isSender:Bool)
	{
		let message = NSEntityDescription.insertNewObject(forEntityName: ChatController.ENTITY_NAME, into: moc) as! ChatMessage
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
			Log.error("APP", "Error storing persistent data: \(error.localizedDescription).")
			return
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - NSFetchedResultsControllerDelegate
	// ----------------------------------------------------------------------------------------------------
	
	func controller(_ controller:NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:Any, at indexPath:IndexPath?, for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?)
	{
		if let delegate = delegate, let newIndexPath = newIndexPath
		{
			delegate.onFetchedResultsChanged(type: type, newIndexPath: newIndexPath)
		}
	}
	
	
	func controllerWillChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>)
	{
		if let delegate = delegate
		{
			delegate.onWillChangeContent()
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
