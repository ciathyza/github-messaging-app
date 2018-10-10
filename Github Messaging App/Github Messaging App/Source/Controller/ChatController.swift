//
// ChatController.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/10.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// Manages the sending an receiving of chat messages.
///
class ChatController
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	private var _chatMessages = [String:[ChatMessage]]()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Init
	// ----------------------------------------------------------------------------------------------------
	
	init()
	{
		sendMessageTo(userID: "mojombo" , text: "Some Test")
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
			if _chatMessages[userID] == nil
			{
				_chatMessages[userID] = [ChatMessage]()
			}
			
			let message = ChatMessage()
			message.text = text
			message.date = Date()
			message.userID = userID
			message.isSender = true
			
			if var a = _chatMessages[userID]
			{
				a.append(message)
				_chatMessages[userID] = a
			}
			
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
			if _chatMessages[userID] == nil
			{
				_chatMessages[userID] = [ChatMessage]()
			}
			
			let message = ChatMessage()
			message.text = text
			message.date = Date()
			message.userID = userID
			message.isSender = false
			
			if var a = _chatMessages[userID]
			{
				a.append(message)
				_chatMessages[userID] = a
			}
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
}
