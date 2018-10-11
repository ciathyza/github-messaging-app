//
// String.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/11.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


extension String
{
	var isNumber:Bool
	{
		get
		{
			return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
		}
	}
}
