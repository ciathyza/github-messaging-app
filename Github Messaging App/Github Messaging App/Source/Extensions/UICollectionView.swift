//
// UICollectionView.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/11.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


extension UICollectionView
{
	func isValid(indexPath: IndexPath) -> Bool
	{
		if indexPath.section >= numberOfSections { return false }
		if indexPath.row >= numberOfItems(inSection: indexPath.section) { return false }
		return true
	}
}
