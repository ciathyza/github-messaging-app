//
// GitHubAPI.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// Provides methods to retrieve data from Github, using Github's dev API.
///
public class GitHubAPI
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Singleton
	// ----------------------------------------------------------------------------------------------------
	
	internal static let shared = GitHubAPI()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Constants
	// ----------------------------------------------------------------------------------------------------
	
	private let SERVICE_URL = "https://api.github.com/"
	private var _urlSession:URLSession
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Constructor
	// ----------------------------------------------------------------------------------------------------
	
	init()
	{
		/* Let's use our own url session with a set timeout. */
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 60
		config.timeoutIntervalForResource = 60
		_urlSession = URLSession(configuration: config)
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	///
	/// Fetches a number of users from Github.
	///
	internal func getUsers(since:Int = 0, callback:@escaping (([GitHubUser]?, String?) -> Void))
	{
		let since = since < 0 ? 0 : since > Int.max ? Int.max : since
		if let url = URL(string: "\(SERVICE_URL)users?since=\(since)")
		{
			/* Fetch data on background thread. */
			DispatchQueue.global(qos: .background).async
			{
				let task = self._urlSession.userTask(with: url)
				{
					data, response, error in
					if let error = error
					{
						DispatchQueue.main.async
						{
							callback(nil, error.localizedDescription)
						}
					}
					else if let jsonArray = data
					{
						var a = [GitHubUser]()
						for i in jsonArray
						{
							a.append(i)
						}
						/* Back to main thread. */
						DispatchQueue.main.async
						{
							callback(a, nil)
						}
					}
				}
				task.resume()
			}
		}
	}
}
