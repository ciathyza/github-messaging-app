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
/// Represents the data for a GitHub user.
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
		case nodeID            = "node_id"
		case avatarURL         = "avatar_url"
		case gravatarID        = "gravatar_id"
		case url
		case htmlURL           = "html_url"
		case followersURL      = "followers_url"
		case followingURL      = "following_url"
		case gistsURL          = "gists_url"
		case starredURL        = "starred_url"
		case subscriptionsURL  = "subscriptions_url"
		case organizationsURL  = "organizations_url"
		case reposURL          = "repos_url"
		case eventsURL         = "events_url"
		case receivedEventsURL = "received_events_url"
		case type
		case siteAdmin         = "site_admin"
	}
	
	public func toString() -> String
	{
		return "[GitHubUser id=\(id), login=\(login), avatarURL=\(avatarURL)]"
	}
}
