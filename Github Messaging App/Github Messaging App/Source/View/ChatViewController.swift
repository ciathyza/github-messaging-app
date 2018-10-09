//
//  ChatViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _navigationItem:UINavigationItem!
	@IBOutlet weak var _collectionView:UICollectionView!
	@IBOutlet weak var _containerView:UIView!
	@IBOutlet weak var _bottomConstraint: NSLayoutConstraint!
	
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
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
		
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

	///
	/// Takes care of moving the views up or down when the soft keyboard appears/disappears.
	///
	@objc func onKeyboardNotification(notification:Notification)
	{
		if let userInfo = notification.userInfo
		{
			if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]) as? CGRect
			{
				let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
				_bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
				
				UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations:
				{
					self.view.layoutIfNeeded()
				}, completion:
				{
					(completed) in
					if isKeyboardShowing
					{
						//let lastItem = self.fetchedResultsControler.sections![0].numberOfObjects - 1
						//let indexPath = NSIndexPath(item: lastItem, section: 0)
						//self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
					}
				})
			}
		}
	}
	

	///
	/// Closes soft keyboard if the user taps anywhere else.
	///
	@objc func onViewTap(_ recognizer:UIGestureRecognizer)
	{
		_ = _inputViewController?.resignFirstResponder()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDelegate
	// ----------------------------------------------------------------------------------------------------
	
	/// didSelectItemAt
	func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath:IndexPath)
	{
		_inputViewController?.endEditing()
	}
	
	
	/// cellForItemAt
	func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatMessageCell", for: indexPath) as! ChatMessageCellView
		let message = ChatMessage()
		
		cell.messageTextView.text = message.text
		
		if let messageText = message.text
		{
			let size = CGSize(width: 250, height:1000)
			let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
			let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
			
			/* Incoming message. */
			if message.isSender == nil || !message.isSender!.boolValue
			{
				cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
				cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
				cell.bubbleImageView.image = ChatMessageCellView.leftBubbleImage
				cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
				cell.messageTextView.textColor = UIColor.black
			}
			/* Outgoing message. */
			else
			{
				cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
				cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
				cell.bubbleImageView.image = ChatMessageCellView.rightBubbleImage
				cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137 / 255, blue: 249 / 255, alpha: 1)
				cell.messageTextView.textColor = UIColor.white
			}
		}
		
		return cell
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDataSource
	// ----------------------------------------------------------------------------------------------------
	
	/// numberOfItemsInSection
	func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		return AppDelegate.shared.model.chatMessages.count
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDelegateFlowLayout
	// ----------------------------------------------------------------------------------------------------
	
	/// sizeForItemAt
	func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize
	{
		let message = AppDelegate.shared.model.chatMessages[indexPath.row]
		if let messageText = message.text
		{
			let size = CGSize(width: 250, height: 1000)
			let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
			let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
			return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
		}
		return CGSize(width: view.frame.width, height: 100)
	}
	
	
	/// insetForSectionAt
	func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, insetForSectionAt section:Int) -> UIEdgeInsets
	{
		return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
	}
}
