//
//  WTFViewController.swift
//  WTF
//
//  Created by Solomon Rajkumar on 23/04/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import UIKit
import SwiftLocation
import UberRides
import CoreLocation

class WTFViewController: UIViewController {
    
    let ridesClient = RidesClient()
    let rideRequestbutton = RideRequestButton()
    
    let restaurantObject = Restaurant()
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var cuisinesLabel: UILabel!
    
    @IBOutlet weak var restaurantRatingsLabel: UILabel!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // center button
        rideRequestbutton.center = bottomView.center
        
        //put the button in the view
        view.addSubview(rideRequestbutton)
        
        // to get shake gesture
        self.becomeFirstResponder()
        
        // Determine the user's location
        Location.getLocation(accuracy: .block, frequency: .oneShot, timeout: 30,
                             success: {
                                (locationRequest, userLocation) in
                                // set the latitude and longitude in the singleton user location object
                                userLocationObject._latitude = "\(userLocation.coordinate.latitude)"
                                userLocationObject._longitude = "\(userLocation.coordinate.longitude)"
                                
                                // search for a nearby restaurant based on user's location
                                self.restaurantObject.searchRestaurant() {
                                    // update all relevant labels
                                    self.updateUI()
                                    self.searchUberRide(rideRequestbutton: self.rideRequestbutton, userLocationLatitude: userLocationObject._latitude, userLocationLongitude: userLocationObject._longitude)
                                }
        }, error: {
            (locationRequest, lastLocation, error) in
            print(error)
        })
        
    }
    
    // To become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion and change restaurant suggestion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            restaurantObject.searchForNewRestaurant(singletonHttpResponseObject: singletonHttpResponseObject)
            // update all relevant labels
            updateUI()
            // search for uber based on new restaurant found
            searchUberRide(rideRequestbutton: self.rideRequestbutton, userLocationLatitude: userLocationObject._latitude, userLocationLongitude: userLocationObject._longitude)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func launchZomatoAction(_ sender: Any) {
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
        
    }
    
    // Description : Function to search for a new restaurant
    @IBAction func searchAgainAction(_ sender: Any) {
        restaurantObject.searchForNewRestaurant(singletonHttpResponseObject: singletonHttpResponseObject)
        // update all relevant labels
        updateUI()
        self.searchUberRide(rideRequestbutton: self.rideRequestbutton, userLocationLatitude: userLocationObject._latitude, userLocationLongitude: userLocationObject._longitude)
    }
    
    // Description : Updates all labels in the UI
    func updateUI(){
        // set the name of the restaurant
        self.restaurantNameLabel.text = PREFIX_RESTAURANT_NAME + self.restaurantObject.restaurantName + SUFFIX_RESTAURANT_NAME
        // set the restaurant cuisine
        self.cuisinesLabel.text = PREFIX_RESTAURANT_CUISINE + self.restaurantObject.restaurantCuisine
        // set the restaurant rating
        self.restaurantRatingsLabel.text = PREFIX_RESTAURANT_RATING + self.restaurantObject.restaurantRating
    }
    
    
    func searchUberRide(rideRequestbutton: RideRequestButton, userLocationLatitude: String, userLocationLongitude: String){
        // set the drop off location and pickup location
        let dropoffLocation = CLLocation(latitude: CLLocationDegrees(restaurantObject.restaurantLatitude)!, longitude: CLLocationDegrees(restaurantObject.restaurantLongitude)!)
        let pickupLocation = CLLocation(latitude: CLLocationDegrees(userLocationLatitude)!, longitude: CLLocationDegrees(userLocationLongitude)!)
        
        //make sure that the pickupLocation is set in the Deeplink
        let builder = RideParametersBuilder()
            .setPickupLocation(pickupLocation, nickname: "You")
            .setDropoffLocation(dropoffLocation, nickname: restaurantObject.restaurantName)
        
        
        // use the same pickupLocation to get the estimate
        ridesClient.fetchCheapestProduct(pickupLocation: pickupLocation, completion: {
            product, response in
            if let productID = product?.productID { //check if the productID exists
                builder.setProductID(productID)
                rideRequestbutton.rideParameters = builder.build()
                
                // show estimates in the button
                rideRequestbutton.loadRideInformation()
            }
        })
    }
    
}

