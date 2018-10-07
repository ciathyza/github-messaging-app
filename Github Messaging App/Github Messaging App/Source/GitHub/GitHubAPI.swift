//
// GitHubAPI.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


public class GitHubAPI
{
	public static let instance = GitHubAPI()
	
	
	private let SERVICE_URL = "https://api.github.com/"
	
	
	public func getUsers(since:Int = 0)
	{
		let since = since < 0 ? 0 : since
		if let url = URL(string: "\(SERVICE_URL)users?since=\(since)")
		{
			let task = URLSession.shared.userTask(with: url)
			{
				userData, response, error in
				if let jsonArray = userData
				{
					var a = [GitHubUser]()
					for i in jsonArray
					{
						a.append(i)
						Log.debug("App", i.toString())
					}
				}
			}
			task.resume()
		}
	}
}
