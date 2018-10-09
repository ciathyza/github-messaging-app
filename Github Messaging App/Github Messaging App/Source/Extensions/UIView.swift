//
// UIView.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/09.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


extension UIView
{
	func addConstraintsWithFormat(format:String, views:UIView...)
	{
		var viewsDictionary = [String: UIView]()
		for (index, view) in views.enumerated()
		{
			let key = "v\(index)"
			viewsDictionary[key] = view
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
	}
}
