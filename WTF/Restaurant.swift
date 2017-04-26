//
//  Restaurant.swift
//  WTF
//
//  Created by Solomon Rajkumar on 23/04/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//


// Class to store Restaurant Details
import Foundation
import Alamofire

class Restaurant{
    
    
    // Restaurant Name variable
    var _restaurantName: String!
    
    // Getter for Restaurant name
    var restaurantName: String{
        if _restaurantName == nil{
            _restaurantName = ""
        }
        return _restaurantName
    }
    
    // Zomato link for the restaurant
    var _zomatoLinkForRestaurant: String!
    
    // Get the Zomato Link
    var zomatoLinkForRestaurant: String{
        if _zomatoLinkForRestaurant == nil{
            _zomatoLinkForRestaurant = ""
        }
        return _zomatoLinkForRestaurant
    }
    
    // Description : Search Restaurant function
    //
    // List of Arguments
    // completed: completion handler
    
    func searchRestaurant(completed: @escaping SearchComplete){
        
        // query string for searching based on latitude and longitude
        let queryString = [
            "lat": userLocationObject.latitude,
            "lon": userLocationObject.longitude
        ]
        
        // Make the http get request for restaurant search
        Alamofire.request(ZOMATO_SEARCH_RESTAURANT_URL, method: .get, parameters: queryString, headers: ZOMATO_API_HEADERS)
            .responseJSON { response in
                if let httpResponseObject = response.result.value as? Dictionary<String, AnyObject> {
                    // Search for restaurants Dictionary Array
                    if let restaurantListObject = httpResponseObject["restaurants"] as? [Dictionary<String, AnyObject>]{
                        // Search for restaurants Dictionary
                        if let restaurantObject = restaurantListObject[0]["restaurant"] as? Dictionary<String, AnyObject>{
                            // Retrieve the restaurant's name
                            if let restaurantName = restaurantObject["name"] as? String{
                                self._restaurantName = restaurantName
                                print(self.restaurantName)
                            } else{
                                // if restaurant name is not present
                                print("Restaurant name is missing!")
                            }
                            // Retrieve the zomato link
                            if let zomatoLinkForRestaurant = restaurantObject["deeplink"] as? String{
                                self._zomatoLinkForRestaurant = zomatoLinkForRestaurant
                            } else{
                                // if restaurant link is not present
                                print("Restaurant link is missing!")
                            }
                            completed()
                        } else{
                            // if restaurant object is missing
                            print("Missing restaurant!")
                        }
                    } else{
                        // if list of restaurants is missing
                        print("List of restaurants is missing!")
                    }
                } else{
                    print()
                }
        }
    }
    
}
