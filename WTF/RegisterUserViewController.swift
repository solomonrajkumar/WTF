//
//  RegisterUserViewController.swift
//  WTF
//
//  Created by Solomon Rajkumar on 26/05/17.
//  Copyright © 2017 Solomon Rajkumar. All rights reserved.
//

import UIKit
import Alamofire

class RegisterUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var firstName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameTextField.autocorrectionType = .no
        lastNameTextField.autocorrectionType = .no
        userNameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterUserViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func registerUserAction(_ sender: Any) {
        
        let firstname = self.firstNameTextField.text!
        let lastname = self.lastNameTextField.text!
        let username = self.userNameTextField.text!
        let password = self.passwordTextField.text!
        
        // will be sent to WTF VC
        firstName = firstname
        
        let requestBody = [
            "firstname" : firstname,
            "lastname" : lastname,
            "username": username,
            "password": password
        ]
        
        // Make the http get request for restaurant search
        Alamofire.request("http://192.168.0.100:3000/register", method: .post, parameters: requestBody,encoding: JSONEncoding.default)
            .responseJSON { response in
                if (response.result.value as? Dictionary<String, AnyObject>) != nil {
                    let statusCode = (response.response?.statusCode)!
                    
                    var alert = UIAlertController()
                    
                    if statusCode == 200{
                        alert = UIAlertController(title: "Success!", message: "Registration successful", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                            (alert: UIAlertAction!) in self.performSegue(withIdentifier: "unwindToWTFFromRegisterSegue", sender: self.firstName)
                        }))
                    } else if statusCode == 409{
                        alert = UIAlertController(title: "Error", message: "UserName already exists", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: {
                            (alert: UIAlertAction!) in self.clearTextFields()
                        }))
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else{
                    print("Failed API call!")
                }
        }
        
    }
    
    
    @IBAction func cancelRegisterAction(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToLoginFromRegisterSegue", sender: self)

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
    
    func clearTextFields(){
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindToWTFFromRegisterSegue" {
            
            let firstName = sender as! String
            
            let destinationViewController = segue.destination as! WTFViewController
            destinationViewController.userFirstName = "\(firstName)!"
        }
        
    }

}
