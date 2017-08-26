//
//  LoginViewController.swift
//  WTF
//
//  Created by Solomon Rajkumar on 26/05/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        userNameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeLoginView(_ sender: Any) {
        performSegue(withIdentifier: "unwindToWTFFromLoginSegue", sender: self)
        
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        view.endEditing(true)
        
        let userName = self.userNameTextField.text!
        let password = self.passwordTextField.text!
        
        let requestBody = [
            "username" : userName,
            "password" : password
        ]
        
        // Make the http get request for restaurant search
        Alamofire.request("http://192.168.0.103:3000/login", method: .post, parameters: requestBody,encoding: JSONEncoding.default)
            .responseJSON { response in
                if let httpResponseObject = response.result.value as? Dictionary<String, AnyObject> {
                    
                    let statusCode = (response.response?.statusCode)!
                    
                    var alert = UIAlertController()
                    
                    if statusCode == 200{
                        let firstName = httpResponseObject["first_name"]!
                        alert = UIAlertController(title: "Success!", message: "Authentication successful", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                            (alert: UIAlertAction!) in self.performSegue(withIdentifier: "unwindToWTFFromLoginSegue", sender: firstName)
                        }))
                    } else{
                        alert = UIAlertController(title: "Error", message: "Invalid Credentials!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: {
                            (alert: UIAlertAction!) in self.clearCredentials()
                        }))
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else{
                    print("Failed API call!")
                }
        }

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindToWTFFromLoginSegue" {
            
            if let firstName = sender as? String{
            
                let destinationViewController = segue.destination as! WTFViewController
                destinationViewController.userFirstName = "\(firstName)!"
            }
        }
        
    }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func clearCredentials(){
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func unwindToLoginViewController(sender: UIStoryboardSegue) {
    }


}
