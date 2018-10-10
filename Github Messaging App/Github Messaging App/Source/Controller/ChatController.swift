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
		sendMessageTo(user: "mojombo" , text: "Some Test")
		sendMessageTo(user: "mojombo" , text: "Another Test")
		receiveMessageFrom(user: "mojombo" , text: "Hi there!")
		sendMessageTo(user: "mojombo" , text: "A very long message with a lot of text and stuff. And more text and letters for extra more text.")
		sendMessageTo(user: "mojombo" , text: "Du dumme sau!")
		receiveMessageFrom(user: "mojombo" , text: "Was geht ab?")
		sendMessageTo(user: "mojombo" , text: "Another text")
		receiveMessageFrom(user: "mojombo" , text: "A looooooooooooooooong text!!!!")
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	internal func sendMessageTo(user:String?, text:String)
	{
		if let user = user
		{
			if _chatMessages[user] == nil
			{
				_chatMessages[user] = [ChatMessage]()
			}
			
			let message = ChatMessage()
			message.text = text
			message.date = Date()
			message.isSender = true
			
			if var a = _chatMessages[user]
			{
				a.append(message)
				_chatMessages[user] = a
			}
		}
	}
	
	
	internal func receiveMessageFrom(user:String?, text:String)
	{
		if let user = user
		{
			if _chatMessages[user] == nil
			{
				_chatMessages[user] = [ChatMessage]()
			}
			
			let message = ChatMessage()
			message.text = text
			message.date = Date()
			message.isSender = false
			
			if var a = _chatMessages[user]
			{
				a.append(message)
				_chatMessages[user] = a
			}
		}
	}
	
	
	internal func getMessageCountFor(user:String?) -> Int
	{
		if let user = user, let messages = _chatMessages[user] { return messages.count }
		return 0
	}
	
	
	internal func getMessagesFor(user:String?) -> [ChatMessage]?
	{
		if let user = user, let messages = _chatMessages[user] { return messages }
		return nil
	}
	
	
	internal func getMessageAtIndexFor(user:String?, index:Int) -> ChatMessage?
	{
		if let user = user, let messages = _chatMessages[user]
		{
			if index < 0 || index >= messages.count { return nil }
			return messages[index]
		}
		return nil
	}
}
