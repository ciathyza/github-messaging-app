//
//  UserListTableViewCell.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/07.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class UserListTableViewCell: UITableViewCell
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _imageView:UIImageView!
	@IBOutlet weak var _label:UILabel!
	
	
	var labelText:String
	{
		get { return _label.text ?? "" }
		set(value) { _label.text = value }
	}
}
