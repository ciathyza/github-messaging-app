//
// GitHubUser.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


typealias User = [GitHubUser]


///
/// Data model for a GitHub user.
///
struct GitHubUser: Codable
{
	let login:String
	let id:Int
	let nodeID:String
	let avatarURL:String
	let gravatarID:String
	let url, htmlURL, followersURL:String
	let followingURL, gistsURL, starredURL:String
	let subscriptionsURL, organizationsURL, reposURL:String
	let eventsURL:String
	let receivedEventsURL:String
	let type:String
	let siteAdmin:Bool
	
	
	enum CodingKeys: String, CodingKey
	{
		case login, id
		case nodeID = "node_id"
		case avatarURL = "avatar_url"
		case gravatarID = "gravatar_id"
		case url
		case htmlURL = "html_url"
		case followersURL = "followers_url"
		case followingURL = "following_url"
		case gistsURL = "gists_url"
		case starredURL = "starred_url"
		case subscriptionsURL = "subscriptions_url"
		case organizationsURL = "organizations_url"
		case reposURL = "repos_url"
		case eventsURL = "events_url"
		case receivedEventsURL = "received_events_url"
		case type
		case siteAdmin = "site_admin"
	}
	
	public func toString() -> String
	{
		return "[GitHubUser id=\(id), login=\(login), avatarURL=\(avatarURL)]"
	}
}


func newJSONDecoder() -> JSONDecoder
{
	let decoder = JSONDecoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *)
	{
		decoder.dateDecodingStrategy = .iso8601
	}
	return decoder
}


func newJSONEncoder() -> JSONEncoder
{
	let encoder = JSONEncoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *)
	{
		encoder.dateEncodingStrategy = .iso8601
	}
	return encoder
}


// ----------------------------------------------------------------------------------------------------
// MARK: - URLSession response handlers
// ----------------------------------------------------------------------------------------------------

extension URLSession
{
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
	
	
	func userTask(with url:URL, completionHandler:@escaping (User?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
	{
		return self.codableTask(with: url, completionHandler: completionHandler)
	}
}
