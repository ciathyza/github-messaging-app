//
//  ChatMessageCellView.swift
//  Github Messaging App
//
//  Created by Sascha on 2018/10/08.
//  Copyright © 2018 Ciathyza. All rights reserved.
//

import UIKit


class ChatMessageCellView : UICollectionViewCell
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Constants
	// ----------------------------------------------------------------------------------------------------
	
	static let leftBubbleImage = UIImage(named: "left_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 13, left: 20, bottom: 16, right: 30), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
	static let rightBubbleImage = UIImage(named: "right_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 13, left: 14, bottom: 16, right: 21), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Computed Properties
	// ----------------------------------------------------------------------------------------------------
	
	let messageTextView:UITextView =
	{
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 18)
		textView.text = "Sample message"
		textView.backgroundColor = UIColor.clear
		return textView
	}()
	
	let textBubbleView:UIView =
	{
		let view = UIView()
		view.layer.cornerRadius = 15
		view.layer.masksToBounds = true
		return view
	}()
	
	let bubbleImageView:UIImageView =
	{
		let imageView = UIImageView()
		imageView.image = ChatMessageCellView.leftBubbleImage
		imageView.tintColor = UIColor(white: 0.90, alpha: 1)
		return imageView
	}()
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Init
	// ----------------------------------------------------------------------------------------------------
	
	override init(frame:CGRect)
	{
		super.init(frame: frame)
		setup()
	}
	
	
	required init?(coder aDecoder:NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	private func setup()
	{
		addSubview(textBubbleView)
		addSubview(messageTextView)
		
		textBubbleView.addSubview(bubbleImageView)
		textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
		textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
	}
}
