//
// UIImageView.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


let imageCache = NSCache<NSString, UIImage>()


///
/// Extensions for UIImageView.
///
extension UIImageView
{
	///
	/// Loads an image from a URL into the image view. If the image is already cached
	/// it will be pulled from the cache.
	///
	func loadImageUsingCache(withUrl urlString:String)
	{
		let url = URL(string: urlString)
		if url == nil { return }
		//self.image = nil
		setRoundedImage(nil)
		
		// check cached image
		if let cachedImage = imageCache.object(forKey: urlString as NSString)
		{
			Log.debug("APP", "Reusing cached image for \(urlString).")
			//self.image = cachedImage
			setRoundedImage(cachedImage)
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
					//self.image = image
					self.setRoundedImage(image)
					activityIndicator.removeFromSuperview()
				}
			}
			
		}).resume()
	}
	
	
	func setRoundedImage(_ image:UIImage?)
	{
		self.image = image
		if self.image != nil
		{
			/* Frame width and height needs to be the same or the the rounded image
			   will look strange. */
			self.layer.masksToBounds = true
			self.layer.cornerRadius = self.frame.height / 2.0
		}
	}
}
