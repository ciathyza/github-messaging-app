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
/// Manages the sending an receiving of chat messages.
///
class ChatController : NSObject, NSFetchedResultsControllerDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	private var _chatMessages = [String:[ChatMessage]]()
	private var _blockOperations = [BlockOperation]()
	
	private lazy var fetchedResultsControler:NSFetchedResultsController =
	{
		() -> NSFetchedResultsController<NSFetchRequestResult> in
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatMessage")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		//fetchRequest.predicate = NSPredicate(format: "userID = %@", self.friend!.name!)
		let delegate = AppDelegate.shared
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		return frc
	}()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	private var moc:NSManagedObjectContext
	{
		get {return AppDelegate.shared.managedObjectContext }
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
			//if _chatMessages[userID] == nil { _chatMessages[userID] = [ChatMessage]() }
			//let message = ChatMessage()
			//message.text = text
			//message.date = NSDate()
			//message.userID = userID
			//message.isSender = true
			//
			//if var a = _chatMessages[userID]
			//{
			//	a.append(message)
			//	_chatMessages[userID] = a
			//}
			
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
			//if _chatMessages[userID] == nil { _chatMessages[userID] = [ChatMessage]() }
			//let message = ChatMessage()
			//message.text = text
			//message.date = NSDate()
			//message.userID = userID
			//message.isSender = false
			//
			//if var a = _chatMessages[userID]
			//{
			//	a.append(message)
			//	_chatMessages[userID] = a
			//}
			
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
	
	
	internal func getMessageCountFor(userID:String?) -> Int
	{
		if let userID = userID, let messages = _chatMessages[userID] { return messages.count }
		return 0
	}
	
	
	internal func getMessageCount() -> Int
	{
		return fetchedResultsControler.sections?[0].numberOfObjects ?? 0
	}
	
	
	internal func getMessagesFor(userID:String?) -> [ChatMessage]?
	{
		if let userID = userID, let messages = _chatMessages[userID] { return messages }
		return nil
	}
	
	
	internal func getMessageAtIndexFor(userID:String?, index:Int) -> ChatMessage?
	{
		if let userID = userID, let messages = _chatMessages[userID]
		{
			if index < 0 || index >= messages.count { return nil }
			return messages[index]
		}
		return nil
	}
	
	
	internal func getMessageAtIndexPath(indexPath:IndexPath) -> ChatMessage
	{
		return fetchedResultsControler.object(at: indexPath) as! ChatMessage
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Persistent Data Management
	// ----------------------------------------------------------------------------------------------------
	
	func performFetch()
	{
		do
		{
			try fetchedResultsControler.performFetch()
			Log.debug("APP", "Fetched \(fetchedResultsControler.sections?[0].numberOfObjects ?? 0) objects.")
		}
		catch let error
		{
			Log.error("APP", "Error performing fetch: \(error.localizedDescription).")
		}
	}
	
	func storeChatMessage(_ userID:String, _ text:String, _ isSender:Bool)
	{
		let message = NSEntityDescription.insertNewObject(forEntityName: "ChatMessage", into: moc) as! ChatMessage
		message.text = text
		message.date = NSDate()
		message.userID = userID
		message.isSender = true
		
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
	
	
	func loadChatMessages() -> [ChatMessage]?
	{
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatMessage")
		let messages:[ChatMessage]?
		do
		{
			messages = try moc.fetch(request) as? [ChatMessage]
			Log.debug("APP", "Loaded \(messages?.count ?? 0) chat messages.")
			return messages
		}
		catch let error
		{
			Log.error("APP", "Error loading chat messages: \(error.localizedDescription).")
		}
		return nil
	}
	
	
	func clearChatMessages()
	{
		do
		{
			let entityNames = ["ChatMessage"]
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
		if type == .insert
		{
			_blockOperations.append(BlockOperation(block:
			{
				// TODO
				//self.collectionView?.insertItems(at: [newIndexPath!])
			}))
		}
	}
	
	
	func controllerDidChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>)
	{
		// TODO
//		collectionView?.performBatchUpdates(
//		{
//			for operation in self.blockOperations
//			{
//				operation.start()
//			}
//		}, completion:
//		{
//			(completed) in
//			let lastItem = self.fetchedResultsControler.sections![0].numberOfObjects - 1
//			let indexPath = NSIndexPath(item: lastItem, section: 0)
//			self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
//		})
	}
}
