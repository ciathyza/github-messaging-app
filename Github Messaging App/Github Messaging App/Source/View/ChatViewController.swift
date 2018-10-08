//
//  ChatViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class ChatViewController : UIViewController
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _navigationItem: UINavigationItem!
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		/* Set navitem title to current user's name. */
		if let user = AppDelegate.shared.model.currentUser
		{
			_navigationItem.title = "@\(user.login)"
		}
	}
}
