//
//  MessageInputViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


///
/// Manages logic for the text input area and the send button.
///
class MessageInputViewController: UIViewController, UITextViewDelegate
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _placeholderTextView: UITextView!
	@IBOutlet weak var _textView:UITextView!
	@IBOutlet weak var _postbutton:UIButton!
	

	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Set initial state for text input view and send button. */
		_placeholderTextView.isHidden = !_textView.text.isEmpty
		_postbutton.isEnabled = !_textView.text.isEmpty
	}
	
	
	override func resignFirstResponder() -> Bool
	{
		_textView.resignFirstResponder()
		return super.resignFirstResponder()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - UITextViewDelegate
	// ----------------------------------------------------------------------------------------------------
	
	private func textViewDidBeginEditing(_ textView:UITextView)
	{
		_placeholderTextView.isHidden = !_textView.text.isEmpty
		_postbutton.isEnabled = !_textView.text.isEmpty
		textView.becomeFirstResponder()
	}
	
	
	private func textViewDidEndEditing(_ textView:UITextView)
	{
		_placeholderTextView.isHidden = !_textView.text.isEmpty
		_postbutton.isEnabled = !_textView.text.isEmpty
		textView.resignFirstResponder()
	}
	
	
	func textViewDidChange(_ textView:UITextView)
	{
		_placeholderTextView.isHidden = !_textView.text.isEmpty
		_postbutton.isEnabled = !_textView.text.isEmpty
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Handlers
	// ----------------------------------------------------------------------------------------------------
	
	@IBAction func onSendButtonTap(_ sender:Any)
	{
	}
}
