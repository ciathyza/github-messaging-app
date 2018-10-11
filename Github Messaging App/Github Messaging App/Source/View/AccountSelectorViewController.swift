//
//  AccountSelectorViewController.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/06.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class AccountSelectorViewController : UIViewController
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Constants
	// ----------------------------------------------------------------------------------------------------
	
	private let DEFAULT_ACCOUNT_NAME = "ReactiveX"
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	@IBOutlet weak var _promptTextArea: UITextView!
	@IBOutlet weak var _inputTextField: UITextField!
	@IBOutlet weak var _connectButton: UIButton!
	@IBOutlet weak var _infoTextArea: UITextView!
	@IBOutlet weak var _clearDataButton: UIButton!
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - iOS Callbacks
	// ----------------------------------------------------------------------------------------------------
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		/* Set up tap recognizer to release softkeyboard on input field unfocus. */
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:)))
		tapGestureRecognizer.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGestureRecognizer)
		
		if _inputTextField.text?.isEmpty ?? false
		{
			_inputTextField.text = DEFAULT_ACCOUNT_NAME;
		}
	}
	
	
	override func viewWillAppear(_ animated:Bool)
	{
		super.viewWillAppear(animated)
		toggleControls(true)
		_infoTextArea.text = ""
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Handlers
	// ----------------------------------------------------------------------------------------------------
	
	@objc func onViewTap(_ recognizer:UIGestureRecognizer)
	{
		_inputTextField.resignFirstResponder()
	}
	
	
	@IBAction func onConnectButtonTap(_ sender: Any)
	{
		toggleControls(false)
		_infoTextArea.text = "Retrieving data ..."
		
		GitHubAPI.shared.getUsers()
		{
			(userArray:[GitHubUser]?, error:String?) in
			if let error = error
			{
				self._infoTextArea.text = error
				self.toggleControls(true)
			}
			if let a = userArray
			{
				AppDelegate.shared.model.gitHubUsers = a
				Log.debug("APP", "Retrieved \(a.count) GitHub users.")
				self.performSegue(withIdentifier: "showUserListViewSegue", sender: sender)
			}
		}
	}
	
	
	@IBAction func onClearDataButtonTap(_ sender:Any)
	{
		toggleControls(false)
		if AppDelegate.shared.chatController.clearChatMessages()
		{
			_infoTextArea.text = "Cleared all persistent data."
		}
		else
		{
			_infoTextArea.text = "Failed to clear persistent data!"
		}
		
		/* Short delay before enabling controls again, to prevent hammering. */
		DispatchQueue.main.asyncAfter(deadline: .now() + 1)
		{
			self.toggleControls(true)
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Private Methods
	// ----------------------------------------------------------------------------------------------------
	
	private func toggleControls(_ on:Bool)
	{
		_inputTextField.isEnabled = on
		_connectButton.isEnabled = on
		_clearDataButton.isEnabled = on
	}
}
