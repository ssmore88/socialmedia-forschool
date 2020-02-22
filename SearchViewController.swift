//
//  SearchViewController.swift
//  bruincave
//
//  Created by user128030 on 12/26/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var searchUsersTableView: UITableView!
    @IBOutlet weak var searchTF: DesignableUITextField!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var nameArray = [String]()
    var idArray = [Int]()
    var classArray = [String]()
    var fromPicArray = [String]()
    var statusPicArray = [String]()
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let defaults = UserDefaults.standard
        let usernameSet: String = defaults.string(forKey: "username")!
        
        getUsers(username: usernameSet, stri: "")
        
    }
    func getUsers(username: String, stri: String) {
        
        nameArray = [String]()
        idArray = [Int]()
        classArray = [String]()
        fromPicArray = [String]()
        
        let myUrl = URL(string: "http://www.bruincave.com/m/andriod/searchusers.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "s="+stri+"&user="+username;
        
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
                                if let _class = postDict.value(forKey: "class") {
                                    self.classArray.append(_class as! String)
                                }
                                if let fromPic = postDict.value(forKey: "fromPic"){
                                    self.fromPicArray.append(fromPic as! String)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.searchUsersTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ searchUsersTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    
    func tableView(_ searchUsersTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchUsersTableView.dequeueReusableCell(withIdentifier: "searchcell") as! SearchTableViewCell
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.classLabel.text = classArray[indexPath.row]
        
        let fromPicURL = NSURL(string: fromPicArray[indexPath.row])
        
        if fromPicURL != nil {
            let data = NSData(contentsOf: (fromPicURL as URL?)!)
            
            cell.profileImage.image = UIImage(data:  data! as Data)
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

