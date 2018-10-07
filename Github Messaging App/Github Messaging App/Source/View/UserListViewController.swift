//
//  UserListViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/06.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class UserListTableViewController: UITableViewController
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Handlers
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
		return cell
	}
}
