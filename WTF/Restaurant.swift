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
    // Getter the Zomato Link
    var zomatoLinkForRestaurant: String{
        if _zomatoLinkForRestaurant == nil{
            _zomatoLinkForRestaurant = ""
        }
        return _zomatoLinkForRestaurant
    }
    
    // Restaurant Cuisines
    var _restaurantCuisine: String!
    // Getter for cuisines
    var restaurantCuisine: String{
        if _restaurantCuisine == nil{
            _restaurantCuisine = ""
        }
        return _restaurantCuisine
    }
    
    // Restaurant Rating
    var _restaurantRating: String!
    // Getter for Rating
    var restaurantRating: String{
        if _restaurantRating == nil{
            _restaurantRating = ""
        }
        return _restaurantRating
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
                                // set restaurant name
                                self._restaurantName = restaurantName
                            } else{
                                // if restaurant name is not present
                                print("Restaurant name object is missing!")
                            }
                            
                            // Retrieve the zomato link
                            if let zomatoLinkForRestaurant = restaurantObject["deeplink"] as? String{
                                self._zomatoLinkForRestaurant = zomatoLinkForRestaurant
                            } else{
                                // if restaurant link is not present
                                print("Restaurant link object is missing!")
                            }
                            
                            // Retrieve cuisines
                            if let restaurantCuisine = restaurantObject["cuisines"] as? String{
                                self._restaurantCuisine = restaurantCuisine
                            } else{
                                // if restaurant link is not present
                                print("Restaurant cuisines object is missing!")
                            }
                            
                            // Retrieve ratings
                            if let userRating = restaurantObject["user_rating"] as? Dictionary<String, AnyObject>{
                                if let aggregatedRating = userRating["aggregate_rating"] as? String{
                                    self._restaurantRating = aggregatedRating
                                } else{
                                    print("User rating object is missing!")
                                }
                            } else{
                                // if restaurant link is not present
                                print("Restaurant user rating object is missing!")
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
