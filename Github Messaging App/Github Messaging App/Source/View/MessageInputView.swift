//
//  MessageInputViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


///
/// Manages logic for the message text input field and the send button.
///
class MessageInputViewController: UIViewController, UITextFieldDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _textView:UITextField!
	@IBOutlet weak var _postbutton:UIButton!
	

	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		_textView.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(onTextFieldChanged(_:)), name: UITextField.textDidChangeNotification, object: nil)
		updatePostButton()
	}
	
	
	override func resignFirstResponder() -> Bool
	{
		return _textView.resignFirstResponder()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UITextViewDelegate
	// ----------------------------------------------------------------------------------------------------
	
	func textFieldDidBeginEditing(_ textField:UITextField)
	{
		updatePostButton()
		textField.becomeFirstResponder()
	}
	
	
	func textFieldDidEndEditing(_ textField:UITextField)
	{
		updatePostButton()
		textField.resignFirstResponder()
	}
	
	
	func textFieldShouldEndEditing(_ textField:UITextField) -> Bool
	{
		return true
	}
	
	
	@objc func onTextFieldChanged(_ notification:NSNotification)
	{
		updatePostButton()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Handlers
	// ----------------------------------------------------------------------------------------------------
	
	@IBAction func onSendButtonTap(_ sender:Any)
	{
		if let text = _textView.text
		{
			let currentUserID = AppDelegate.shared.model.currentUser?.login ?? nil
			AppDelegate.shared.chatController.sendMessageTo(user: currentUserID, text: text)
			_textView.text = nil
		}
		_ = resignFirstResponder()
		updatePostButton()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	private func updatePostButton()
	{
		_postbutton.isEnabled = _textView.text != nil && !_textView.text!.isEmpty
	}
}
