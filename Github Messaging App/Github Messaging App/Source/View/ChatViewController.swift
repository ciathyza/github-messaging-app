//
//  ChatViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _navigationItem:UINavigationItem!
	@IBOutlet weak var _collectionView:UICollectionView!
	@IBOutlet weak var _containerView:UIView!
	
	private var _inputViewController:MessageInputViewController?
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		/* Set navitem title to current user's name. */
		if let user = AppDelegate.shared.model.currentUser
		{
			_navigationItem.title = "@\(user.login)"
		}
		
		/* Events for keyboard/view resize. */
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		/* Set up tap recognizer to release softkeyboard on input field unfocus. */
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:)))
		tapGestureRecognizer.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	
	override func prepare(for segue:UIStoryboardSegue, sender:Any?)
	{
		/* Obtain ref to embedded input view controller. */
		if segue.identifier == "inputViewEmbedSegue"
		{
			if let vc = segue.destination as? MessageInputViewController
			{
				_inputViewController = vc
			}
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Softkeyboard Events
	// ----------------------------------------------------------------------------------------------------
	
	@objc func keyboardWillShow(_ notification:Notification)
	{
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
		{
			if self.view.frame.origin.y == 0
			{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	
	@objc func keyboardWillHide(_ notification:Notification)
	{
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
		{
			if self.view.frame.origin.y != 0
			{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}
	
	
	@objc func onViewTap(_ recognizer:UIGestureRecognizer)
	{
		_ = _inputViewController?.resignFirstResponder()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDelegate
	// ----------------------------------------------------------------------------------------------------
	
	func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		return 0
	}
	
	
	func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell
	{
		return UICollectionViewCell()
	}
}
