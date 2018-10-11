//
//  ChatViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit
import CoreData


class ChatViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ChatControllerDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _navigationItem:UINavigationItem!
	@IBOutlet weak var _collectionView:UICollectionView!
	@IBOutlet weak var _containerView:UIView!
	@IBOutlet weak var _bottomConstraint: NSLayoutConstraint!
	
	private var _inputViewController:MessageInputViewController?
	private var _chatController:ChatController!
	private var _blockOperations = [BlockOperation]()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		_chatController = ChatController()
		_chatController.delegate = self
		
		_inputViewController?.setChatController(_chatController)
		
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
		tapGestureRecognizer.cancelsTouchesInView = true
		view.addGestureRecognizer(tapGestureRecognizer)
		
		_chatController.loadMessagesForCurrentUser()
		_collectionView.reloadData()
	}
	
	
	override func viewWillAppear(_ animated:Bool)
	{
		scrollToLastItem()
	}
	
	
	override func viewDidDisappear(_ animated:Bool)
	{
		_chatController.delegate = nil
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
						self.scrollToLastItem()
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
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	func calculateEstimatedCellFrame(_ text:String) -> CGRect
	{
		let size = CGSize(width: 250, height: 1000)
		let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
	}
	
	
	func scrollToLastItem()
	{
		let lastItem = self._chatController.getMessageCount() - 1
		let indexPath = IndexPath(item: lastItem, section: 0)
		if _collectionView.isValid(indexPath: indexPath)
		{
			self._collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDelegate
	// ----------------------------------------------------------------------------------------------------
	
	/// didSelectItemAt
	func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath:IndexPath)
	{
		_ = _inputViewController?.resignFirstResponder()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDataSource
	// ----------------------------------------------------------------------------------------------------
	
	/// numberOfItemsInSection
	func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		return _chatController.getMessageCount()
	}
	
	
	/// cellForItemAt
	func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatMessageCell", for: indexPath) as! ChatMessageCellView
		
		if _chatController.isIndexPathValid(indexPath)
		{
			if let message = _chatController.getMessageAtIndexPath(indexPath: indexPath)
			{
				cell.messageTextView.text = message.text
				if let messageText = message.text
				{
					let estimatedFrame = calculateEstimatedCellFrame(messageText)
					cell.updateFrame(estimatedFrame, view.frame.width, message.isSender)
				}
			}
		}
		
		return cell
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UICollectionViewDelegateFlowLayout
	// ----------------------------------------------------------------------------------------------------
	
	/// sizeForItemAt
	func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize
	{
		if let message = _chatController.getMessageAtIndexPath(indexPath: indexPath),
		   let messageText = message.text
		{
			let estimatedFrame = calculateEstimatedCellFrame(messageText)
			return CGSize(width: view.frame.width - 32, height: estimatedFrame.height + 20)
		}
		return CGSize(width: view.frame.width - 32, height: 100)
	}
	
	
	/// insetForSectionAt
	func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, insetForSectionAt section:Int) -> UIEdgeInsets
	{
		return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - ChatControllerDelegate
	// ----------------------------------------------------------------------------------------------------
	
	func onFetchedResultsChanged(type:NSFetchedResultsChangeType, newIndexPath:IndexPath)
	{
		if type == .insert
		{
			_blockOperations.append(BlockOperation(block:
			{
				self._collectionView.insertItems(at: [newIndexPath])
			}))
		}
	}
	
	
	func onWillChangeContent()
	{
		/* Nothing to do here! */
	}
	
	
	func onDidChangeContent()
	{
		_collectionView.performBatchUpdates(
		{
			for operation in self._blockOperations
			{
				operation.start()
			}
		}, completion:
		{
			(completed) in
			self.scrollToLastItem()
		})
	}
}
