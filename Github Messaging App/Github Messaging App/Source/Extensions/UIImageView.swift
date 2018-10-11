//
// UIImageView.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/07.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import UIKit


/// Used to cache user thumbnails.
// TODO Should be moved to a nicer place, not be kept in extensions files.
let imageCache = NSCache<NSString, UIImage>()


///
/// Extensions for UIImageView.
///
extension UIImageView
{
	///
	/// Loads an image from a URL into the image view and caches it.
	/// If the image is already cached it will be pulled from the cache instead.
	///
	func loadImageUsingCache(withUrl urlString:String)
	{
		let url = URL(string: urlString)
		if url == nil { return }
		
		setRoundedImage(nil)
		
		/* Check if the image is already cached. */
		if let cachedImage = imageCache.object(forKey: urlString as NSString)
		{
			setRoundedImage(cachedImage)
			return
		}
		
		/* If not cached, show load indicator and fetch the image. */
		let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
		addSubview(activityIndicator)
		activityIndicator.startAnimating()
		activityIndicator.center = self.center
		
		/* Load operation. */
		URLSession.shared.dataTask(with: url!, completionHandler:
		{
			(data, response, error) in
			if let error = error
			{
				Log.error("APP", "Error loading image: \(error.localizedDescription)")
				DispatchQueue.main.async
				{
					activityIndicator.removeFromSuperview()
				}
				return
			}
			
			DispatchQueue.main.async
			{
				if let data = data, let image = UIImage(data: data)
				{
					imageCache.setObject(image, forKey: urlString as NSString)
					activityIndicator.removeFromSuperview()
					self.setRoundedImage(image)
				}
			}
		}).resume()
	}
	

	///
	/// Sets the UIView's image as being round instead of being square.
	///
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
