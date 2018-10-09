//
// ChatMessage.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/09.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// Data model object representing a chat message that has been received or sent.
///
class ChatMessage
{
	var date:Date?
	var text:String?
	var isSender:NSNumber?
	var user:GitHubUser?
}
