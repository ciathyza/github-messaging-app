//
// JSON.swift
// Github Messaging App
//
// Created by Sascha on 2018/10/10.
// Copyright (c) 2018 Ciathyza. All rights reserved.
//

import Foundation


///
/// JSON Utils
///
public class JSON
{
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Properties
	// ----------------------------------------------------------------------------------------------------
	
	private static var _decoder:JSONDecoder?
	private static var _encoder:JSONEncoder?
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Accessors
	// ----------------------------------------------------------------------------------------------------
	
	///
	/// A reusable JSON decoder.
	///
	private static var decoder:JSONDecoder
	{
		get
		{
			if (_decoder == nil)
			{
				_decoder = JSONDecoder()
				_decoder!.dateDecodingStrategy = .iso8601
			}
			return _decoder!
		}
	}
	
	
	///
	/// A reusable JSON encoder.
	///
	private static var encoder:JSONEncoder
	{
		get
		{
			if (_encoder == nil)
			{
				_encoder = JSONEncoder()
				_encoder!.dateEncodingStrategy = .iso8601
			}
			return _encoder!
		}
	}
	
	
	// ----------------------------------------------------------------------------------------------------
	// MARK: - Methods
	// ----------------------------------------------------------------------------------------------------

	///
	/// Tries to decode the specified data into an object of type T.
	///
	public static func decode<T:Codable>(data:Data?) -> T?
	{
		if let data = data
		{
			do
			{
				let decodedJSON = try decoder.decode(T.self, from: data)
				return decodedJSON
			}
			catch let error
			{
				Log.error("APP", "Failed to decode data. Error was: \(error.localizedDescription)")
			}
		}
		return nil
	}
}
