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
	
	private var _imageURL:String?
	

	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	var labelText:String
	{
		get { return _label.text ?? "" }
		set(value) { _label.text = value }
	}
	
	
	var imageURL:String?
	{
		get { return _imageURL }
		set(value)
		{
			if _imageURL == nil || value != _imageURL
			{
				_imageURL = value
				_imageView.loadImageUsingCache(withUrl: _imageURL!)
			}
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Private Methods
	// ----------------------------------------------------------------------------------------------------
	
}
