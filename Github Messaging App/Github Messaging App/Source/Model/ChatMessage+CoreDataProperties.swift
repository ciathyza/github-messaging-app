//
//  ChatMessage+CoreDataProperties.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/11.
//  Copyright © 2018 Ciathyza. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatMessage
{
	@nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessage>
	{
		return NSFetchRequest<ChatMessage>(entityName: "ChatMessage")
	}
	
	@NSManaged public var date:NSDate?
	@NSManaged public var isSender:Bool
	@NSManaged public var text:String?
	@NSManaged public var userID:String?
}
