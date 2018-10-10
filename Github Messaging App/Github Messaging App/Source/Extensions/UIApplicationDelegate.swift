//
// UIApplicationDelegate.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/11.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


extension UIApplicationDelegate
{
	///
	/// Convenience access to typed app delegate.
	///
	static var shared:Self
	{
		return UIApplication.shared.delegate! as! Self
	}
}
