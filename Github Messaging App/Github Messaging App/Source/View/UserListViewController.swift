//
//  UserListViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/06.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


///
/// View controller for the Github user list.
///
class UserListTableViewController: UITableViewController
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - TableView
	// ----------------------------------------------------------------------------------------------------
	
	override func numberOfSections(in tableView:UITableView) -> Int
	{
		return 1
	}
	
	
	override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
	{
		return AppDelegate.shared.model.gitHubUsers.count
	}
	
	
	override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell", for: indexPath) as! UserListTableViewCell
		cell.labelText = AppDelegate.shared.model.gitHubUsers[indexPath.row].login
		cell.imageURL = AppDelegate.shared.model.gitHubUsers[indexPath.row].avatarURL
		return cell
	}
	
	
	override func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)
		AppDelegate.shared.model.setCurrentUserFromIndex(indexPath.row)
		performSegue(withIdentifier: "showChatViewSegue", sender: self)
	}
}
