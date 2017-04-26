//
//  UserLocation.swift
//  WTF
//
//  Created by Solomon Rajkumar on 26/04/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import Foundation

// SIngleton instance
let userLocationObject = UserLocation()

class UserLocation{
    
    // User location - latitude
    var _latitude: String!
    // Getter for Latitude
    var latitude: String{
        if _latitude == nil{
            _latitude = ""
        }
        return _latitude
    }
    
    // User location - longitude
    var _longitude: String!
    // Getter for longitude
    var longitude: String{
        if _longitude == nil{
            _longitude = ""
        }
        return _longitude
    }
    
}
