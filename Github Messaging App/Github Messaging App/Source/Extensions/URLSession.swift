//
// URLSession.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/08.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// URLSession extensions.
///
extension URLSession
{
	///
	/// Provides a convenient way to use data tasks on URLSession.
	///
	fileprivate func codableTask<T: Codable>(with url:URL, completionHandler:@escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
	{
		return self.dataTask(with: url)
		{
			data, response, error in
			guard let data = data, error == nil else
			{
				completionHandler(nil, response, error)
				return
			}
			completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
		}
	}
	
	
	// TODO I don't like having a data model-specific method in the URLSession extensions! Should be integrated in a different way!
	func userTask(with url:URL, completionHandler:@escaping (User?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
	{
		return self.codableTask(with: url, completionHandler: completionHandler)
	}
}
