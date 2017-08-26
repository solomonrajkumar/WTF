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

// Singleton variable to store the search restaurant http response
var singletonHttpResponseObject: Dictionary<String, AnyObject>!

// Starting index for search results
var start = 0

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
    
    // Restaurant Latitude
    var _restaurantLatitude: String!
    // Getter for Latitude
    var restaurantLatitude: String{
        if _restaurantLatitude == nil{
            _restaurantLatitude = ""
        }
        return _restaurantLatitude
    }
    
    // Restaurant Longitude
    var _restaurantLongitude: String!
    // Getter for Longitude
    var restaurantLongitude: String{
        if _restaurantLongitude == nil{
            _restaurantLongitude = ""
        }
        return _restaurantLongitude
    }
    
    
    // List of suggested restaurants
    var suggestedRestaurantIds = [String]()
    
    // Description : Search Restaurant function
    //
    // List of Arguments
    // completed: completion handler
    
    func searchRestaurant(completed: @escaping SearchComplete){
        
        // query string for searching based on latitude and longitude
        let queryString = [
            "lat": userLocationObject.latitude,
            "lon": userLocationObject.longitude,
            "sort": "rating",
            "start": "\(start)"
        ]
        
        // Make the http get request for restaurant search
        Alamofire.request(ZOMATO_SEARCH_RESTAURANT_URL, method: .get, parameters: queryString, headers: ZOMATO_API_HEADERS)
            .responseJSON { response in
                if let httpResponseObject = response.result.value as? Dictionary<String, AnyObject> {
                    // store the response in the singleton variable
                    singletonHttpResponseObject = httpResponseObject
                    // called on didLoad()
                    self.searchForNewRestaurant(singletonHttpResponseObject: singletonHttpResponseObject)
                    
                    completed()
                } else{
                    print("Failed API call!")
                }
        }
    }
    
    // Description : Search Restaurant function(resuable - both didLoad() and searchAgain())
    //
    // List of Arguments
    // singletonHttpResponseObject: signleton api response object
    
    func searchForNewRestaurant(singletonHttpResponseObject: Dictionary<String, AnyObject>){
        
        // if the user has made 20 search again
        if suggestedRestaurantIds.count == 20{
            suggestedRestaurantIds.removeAll()
            fetchMoreRestaurants()
        }
        
        
        // Search for restaurants Dictionary Array
        if let restaurantListObject = singletonHttpResponseObject["restaurants"] as? [Dictionary<String, AnyObject>]{
            
            // pull a random number between 0 to 19; since zomato search returns 20 results
            let randomNumber = Int(arc4random_uniform(20))
            // Search for restaurants Dictionary
            if let restaurantObject = restaurantListObject[randomNumber]["restaurant"] as? Dictionary<String, AnyObject>{
                // Retrieve the restaurant id
                if let restaurantId = restaurantObject["id"] as? String{
                    
                    
                    // during the first run(didLoad)
                    if suggestedRestaurantIds.isEmpty{
                        suggestedRestaurantIds.append(restaurantId)
                        retrieveRestaurantDetails(restaurantObject: restaurantObject)
                    }
                    // if random function returns the same restaurant, search again
                    else if suggestedRestaurantIds.contains(restaurantId){
                        searchForNewRestaurant(singletonHttpResponseObject: singletonHttpResponseObject)
                    }
                    // if new random restaurant is found
                    else{
                        retrieveRestaurantDetails(restaurantObject: restaurantObject)
                        suggestedRestaurantIds.append(restaurantId)
                    }
                } else{
                    print("Restaurant ID is missing!")
                }
                
            } else{
                // if restaurant object is missing
                print("Missing restaurant!")
            }
        } else{
            // if list of restaurants is missing
            print("List of restaurants is missing!")
        }
        
    }
    
    // Description : Function to retrieve restaurant details - name, cuisines, zomato link and rating
    //
    // List of Arguments
    // restaurantObject: single restaurant object which has all required details
    
    func retrieveRestaurantDetails(restaurantObject: Dictionary<String, AnyObject>){
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
        
        // Retreive restaurant's location
        if let restaurantLocation = restaurantObject["location"] as? Dictionary<String, AnyObject>{
            if let restaurantLatitude = restaurantLocation["latitude"] as? String{
                self._restaurantLatitude = restaurantLatitude
            } else{
                print("Restaurant Latitude object is missing!")
            }
            if let restaurantLongitude = restaurantLocation["longitude"] as? String{
                self._restaurantLongitude = restaurantLongitude
            } else{
                print("Restaurant Latitude object is missing!")
            }
            
        } else{
            // if restaurant link is not present
            print("Restaurant location object is missing!")
        }

    }
    
    // Description : Function to retrieve more restaurants once the first 20 restaurants are skipped
    
    func fetchMoreRestaurants(){
        // pull the next 20 restaurants
        // max limit for zomato search api is 100; so we stop at 80-100
        if start < 80{
            start = start + 20
        } else{
            start = 0
        }
        
        // query string for searching based on latitude and longitude
        let queryString = [
            "lat": userLocationObject.latitude,
            "lon": userLocationObject.longitude,
            "sort": "rating",
            "start": "\(start)"
        ]

        // Make the http get request for restaurant search
        Alamofire.request(ZOMATO_SEARCH_RESTAURANT_URL, method: .get, parameters: queryString, headers: ZOMATO_API_HEADERS)
            .responseJSON { response in
                if let httpResponseObject = response.result.value as? Dictionary<String, AnyObject> {
                    // store the response in the singleton variable
                    singletonHttpResponseObject = httpResponseObject
                    // called on didLoad()
                    //self.searchForNewRestaurant(singletonHttpResponseObject: singletonHttpResponseObject)
                    
                } else{
                    print("Failed API call!")
                }
        }
        
    }
    
}
