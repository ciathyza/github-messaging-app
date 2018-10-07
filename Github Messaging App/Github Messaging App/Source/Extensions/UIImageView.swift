//
// UIImageView.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


let imageCache = NSCache<NSString, UIImage>()


extension UIImageView
{
	func loadImageUsingCache(withUrl urlString:String)
	{
		let url = URL(string: urlString)
		if url == nil { return }
		self.image = nil
		
		// check cached image
		if let cachedImage = imageCache.object(forKey: urlString as NSString)
		{
			Log.debug("APP", "Reusing cached image for \(urlString).")
			self.image = cachedImage
			return
		}
		
		let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
		addSubview(activityIndicator)
		activityIndicator.startAnimating()
		activityIndicator.center = self.center
		
		// if not, download image from url
		URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
			if error != nil
			{
				print(error!)
				return
			}
			
			DispatchQueue.main.async
			{
				if let image = UIImage(data: data!)
				{
					imageCache.setObject(image, forKey: urlString as NSString)
					self.image = image
					activityIndicator.removeFromSuperview()
				}
			}
			
		}).resume()
	}
}
