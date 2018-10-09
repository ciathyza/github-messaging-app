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
	
	private var _chatMessages = [ChatMessage]()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	internal var messageCount:Int
	{
		get { return _chatMessages.count }
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	internal func sendMessage(text:String)
	{
		Log.debug("APP", "Sending message \"\(text)\" ...")
	}
	
	
	internal func receiveMessage()
	{
	
	}
	
	
	internal func getMessageAt(index:Int) -> ChatMessage?
	{
		if index < 0 || index >= _chatMessages.count { return nil }
		return _chatMessages[index]
	}
}
