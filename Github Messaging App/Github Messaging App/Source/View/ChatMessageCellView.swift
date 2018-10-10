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
	
	static let leftBubbleImage = UIImage(named: "left_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 13, left: 20, bottom: 16, right: 30), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
	static let rightBubbleImage = UIImage(named: "right_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 13, left: 14, bottom: 16, right: 21), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Computed Properties
	// ----------------------------------------------------------------------------------------------------
	
	let messageTextView:UITextView =
	{
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 18)
		textView.text = ""
		textView.backgroundColor = UIColor.clear
		textView.isEditable = false
		textView.isSelectable = false
		return textView
	}()
	
	let bubbleImageView:UIImageView =
	{
		let imageView = UIImageView()
		imageView.image = ChatMessageCellView.leftBubbleImage
		imageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
		return imageView
	}()
	
	let textBubbleView:UIView =
	{
		let view = UIView()
		//view.layer.cornerRadius = 15
		//view.layer.masksToBounds = true
		return view
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
		super.init(coder: aDecoder)
		setup()
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------
	
	private func setup()
	{
		//backgroundColor = UIColor.red
		
		addSubview(textBubbleView)
		addSubview(messageTextView)
		
		textBubbleView.addSubview(bubbleImageView)
		textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
		textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
	}
	
	
	internal func updateFrame(_ est:CGRect, _ viewWidth:CGFloat, _ rightBubble:Bool = false)
	{
		if (!rightBubble)
		{
			bubbleImageView.image = ChatMessageCellView.leftBubbleImage
			bubbleImageView.tintColor = UIColor(white: 0.8, alpha: 1.0)
			messageTextView.textColor = UIColor.black
			textBubbleView.frame =  CGRect(x:  0, y: 0, width: est.width + 40, height: est.height + 22)
			messageTextView.frame = CGRect(x: 16, y: 0, width: est.width + 16, height: est.height + 20)
		}
		else
		{
			bubbleImageView.image = ChatMessageCellView.rightBubbleImage
			bubbleImageView.tintColor = UIColor(red: 0, green: 137 / 255, blue: 249 / 255, alpha: 1.0)
			messageTextView.textColor = UIColor.white
			textBubbleView.frame =  CGRect(x: viewWidth - est.width - 62, y: 0, width: est.width + 34, height: est.height + 22)
			messageTextView.frame = CGRect(x: viewWidth - est.width - 52, y: 0, width: est.width + 16, height: est.height + 20)
		}
	}
}
