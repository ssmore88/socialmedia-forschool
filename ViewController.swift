//
//  ViewController.swift
//  bruincave
//
//  Created by user128030 on 5/27/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    var username = ""
    var password = ""
    var loginError = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "username") != nil {
            print("username exists:",defaults.object(forKey: "username") as Any)
            changeStoryBoard()
            
        } else {
            print(defaults.object(forKey: "username") as Any)
        }
    }
    
    @IBAction func invokeLogin(_ sender: UIButton) {
        username = usernameTF.text!
        password = passwordTF.text!
        
        let myUrl = URL(string: "http://www.bruincave.com/m/ios/login.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "usr="+username+"&psw="+password;
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil { 
                    
                    if let postArray = json?["login"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let login = postDict.value(forKey: "loginError") {
                                    self.loginError = login as! Bool
                                    
                                    if(self.loginError == true){
                                        let defaults = UserDefaults.standard
                                        defaults.set(self.username, forKey: "username")
                                        
                                        if defaults.string(forKey: "username") != nil {
                                            print("username exists:",defaults.object(forKey: "username") as Any)
                                            self.changeStoryBoard()
                                            
                                        } else {
                                            print(defaults.object(forKey: "username") as Any)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func changeStoryBoard() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeView") as! SWRevealViewController
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

