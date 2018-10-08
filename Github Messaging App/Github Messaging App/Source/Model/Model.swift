//
// Model.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// Common data model for the application.
///
class Model
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	public var gitHubUsers = [GitHubUser]()
	private var _currentUser:GitHubUser?
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	public var currentUser:GitHubUser?
	{
		get { return _currentUser }
	}
	

	// ----------------------------------------------------------------------------------------------------
	// MARK: - Query Methods
	// ----------------------------------------------------------------------------------------------------
	
	///
	/// Returns the GitHubUser object at specified index, or nil.
	///
	public func getUserAtIndex(_ index:Int) -> GitHubUser?
	{
		/* Out of range! */
		if index < 0 || index >= gitHubUsers.count
		{
			return nil
		}
		return gitHubUsers[index]
	}
	
	
	///
	/// Sets currentUser property with the GitHubUser object found at the specified index.
	///
	public func setCurrentUserFromIndex(_ index:Int)
	{
		_currentUser = getUserAtIndex(index)
	}
}
