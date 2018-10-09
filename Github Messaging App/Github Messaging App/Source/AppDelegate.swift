//
//  AppDelegate.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/06.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	var window:UIWindow?
	var model = Model()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool
	{
		return true
	}
	
	
	func applicationWillResignActive(_ application:UIApplication)
	{
	}
	
	
	func applicationDidEnterBackground(_ application:UIApplication)
	{
	}
	
	
	func applicationWillEnterForeground(_ application:UIApplication)
	{
	}
	
	
	func applicationDidBecomeActive(_ application:UIApplication)
	{
	}
	
	
	func applicationWillTerminate(_ application:UIApplication)
	{
	}
}


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
