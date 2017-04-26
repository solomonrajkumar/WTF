//
//  WTFViewController.swift
//  WTF
//
//  Created by Solomon Rajkumar on 23/04/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import UIKit
import SwiftLocation

class WTFViewController: UIViewController {
    
    let restaurantObject = Restaurant()
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var cuisinesLabel: UILabel!
    
    @IBOutlet weak var restaurantRatingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Determine the user's location
        Location.getLocation(accuracy: .block, frequency: .oneShot, timeout: 30,
                             success: {
                                (locationRequest, userLocation) in
                                // set the latitude and longitude in the singleton user location object
                                userLocationObject._latitude = "\(userLocation.coordinate.latitude)"
                                userLocationObject._longitude = "\(userLocation.coordinate.longitude)"
                                
                                // search for a nearby restaurant based on user's location
                                self.restaurantObject.searchRestaurant {
                                    // set the name of the restaurant
                                    self.restaurantNameLabel.text = PREFIX_RESTAURANT_NAME + self.restaurantObject.restaurantName + SUFFIX_RESTAURANT_NAME
                                    
                                }
                            }, error: {
                                (locationRequest, lastLocation, error) in
                                print(error)
                            })
        
        
        /*
         // search for restaurant and stamp in the label in home page
         restaurantObject.searchRestaurant {
         DispatchQueue.main.async {
         // set the restaurant name label
         self.restaurantNameLabel.text = self.restaurantObject.restaurantName
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func launchZomatoAction(_ sender: Any) {
        /*
         let zomatoURL = NSURL(string: restaurantObject.zomatoLinkForRestaurant)!
         /*
         if UIApplication.shared.canOpenURL(zomatoURL! as URL){
         UIApplication.shared.openURL(zomatoURL! as URL)
         } else{
         //redirect to safari because the user doesn't have Zomato
         UIApplication.shared.openURL(NSURL(string: "http://zomato.com/")! as URL)
         }
         */
         
         if #available(iOS 10.0, *) {
         UIApplication.shared.open(zomatoURL as URL, options: [:], completionHandler: nil)
         } else {
         UIApplication.shared.openURL(zomatoURL as URL)
         }
         */
    }
    
    
}

