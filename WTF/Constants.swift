//
//  Constants.swift
//  WTF
//
//  Created by Solomon Rajkumar on 23/04/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import Foundation


// completion handlers
typealias SearchComplete = () -> ()

// Request Headers for making Zomato API calls
let ZOMATO_API_HEADERS = [
    "user-key": "9be7660e68bb0e570758d492d4bcf7d5",
    "cache-control": "no-cache",
]

// Zomato Base Url
let ZOMATO_BASE_URL = "https://developers.zomato.com/api"
// Zomato API version
let ZOMATO_API_VERSION = "/v2.1"
// Zomato url for search API
let ZOMATO_SEARCH_KEYWORD = "/search"

// Zomato Restaurant search URL
let ZOMATO_SEARCH_RESTAURANT_URL = "\(ZOMATO_BASE_URL)\(ZOMATO_API_VERSION)\(ZOMATO_SEARCH_KEYWORD)"

// Prefix values for Labels
let PREFIX_RESTAURANT_NAME = "Why don't you try \""
let PREFIX_RESTAURANT_CUISINE = "Cuisines: "
let PREFIX_RESTAURANT_RATING = "It has a zomato rating of "

// Suffix values for Labels
let SUFFIX_RESTAURANT_NAME = "\""
