//
//  MessagesViewController.swift
//  bruincave
//
//  Created by user128030 on 7/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var messageUsersTableView: UITableView!
    @IBOutlet weak var searchTF: DesignableUITextField!
    
    var nameArray = [String]()
    var idArray = [Int]()
    var bodyArray = [String]()
    var fromPicArray = [String]()
    var str = ""
    
    @IBAction func searchEdit(_ sender: Any) {
        str = searchTF.text!
        let defaults = UserDefaults.standard
        let usernameSet: String = defaults.string(forKey: "username")!
        print(str)
        getUsers(username: usernameSet, stri: str)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessagesViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let defaults = UserDefaults.standard
        let usernameSet: String = defaults.string(forKey: "username")!
        
        sideMenus()
        getUsers(username: usernameSet, stri: "")
        
    }
    func getUsers(username: String, stri: String) {
        
        nameArray = [String]()
        idArray = [Int]()
        bodyArray = [String]()
        fromPicArray = [String]()
        
        let myUrl = URL(string: "http://www.bruincave.com/m/andriod/users.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "s="+stri+"&o=0&user="+username;
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    
                    if let postArray = json?["usersMsg"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                
                                if let name = postDict.value(forKey: "name") {
                                    self.nameArray.append(name as! String)
                                }
                                if let id = postDict.value(forKey: "id") {
                                    self.idArray.append(id as! Int)
                                }
                                if let body = postDict.value(forKey: "body") {
                                    self.bodyArray.append(body as! String)
                                }
                                if let fromPic = postDict.value(forKey: "fromPic"){
                                    self.fromPicArray.append(fromPic as! String)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.messageUsersTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ messageUsersTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    
    func tableView(_ messageUsersTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageUsersTableView.dequeueReusableCell(withIdentifier: "messageuserscell") as! MessageUsersTableViewCell
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.bodyLabel.text = bodyArray[indexPath.row]
        
        let fromPicURL = NSURL(string: fromPicArray[indexPath.row])
        
        if fromPicURL != nil {
            let data = NSData(contentsOf: (fromPicURL as URL?)!)
            
            cell.userPicImage.image = UIImage(data:  data! as Data)
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
