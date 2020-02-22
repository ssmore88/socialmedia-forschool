//
//  FreshmanViewController.swift
//  bruincave
//
//  Created by user128030 on 7/21/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class FreshmanViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var postTableView: UITableView!
    
    var nameArray = [String]()
    var timeArray = [String]()
    var profilePictureArray = [String]()
    var captionArray = [String]()
    var postPictureArray = [String]()
    
    @IBAction func searchUsers(_ sender: Any) {
        let searchUserVC = self.storyboard?.instantiateViewController(withIdentifier: "searchView") as! SWRevealViewController
        self.present(searchUserVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        var usernameSet: String = ""
        if(defaults.string(forKey: "username") != nil){
            usernameSet = defaults.string(forKey: "username")!
        }
        
        sideMenus()
        
        //change tab picture
        self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "freshmenfilled")
        
        let myUrl = URL(string: "http://www.bruincave.com/m/andriod/bringposts.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "type=0&o=0&user="+usernameSet+"&group=0";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    
                    if let postArray = json?["home"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let name = postDict.value(forKey: "name") {
                                    self.nameArray.append(name as! String)
                                }
                                if let time = postDict.value(forKey: "time_added") {
                                    self.timeArray.append(time as! String)
                                }
                                if let profilepicturelink = postDict.value(forKey: "userpic") {
                                    self.profilePictureArray.append(profilepicturelink as! String)
                                }
                                if let caption = postDict.value(forKey: "body") {
                                    self.captionArray.append(caption as! String)
                                }
                                if let postPicture = postDict.value(forKey: "picture_added"){
                                    self.postPictureArray.append(postPicture as! String)
                                }
                            }
                        }
                    }
                
                    
                    OperationQueue.main.addOperation({
                        self.postTableView.reloadData()
                    })
                    
                
                }
            } catch {
                print(error)
            }
        }
        task.resume()

    }
    
    func tableView(_ postTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    
    func tableView(_ postTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "freshmancell") as! FreshmanTableViewCell
    
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.dateLabel.text = timeArray[indexPath.row]
        cell.captionLabel.text = captionArray[indexPath.row]
    
        
        let imgURL = NSURL(string: profilePictureArray[indexPath.row])
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.profileImage.image = UIImage(data: data! as Data)
        }
        
        let postimgURL = NSURL(string: postPictureArray[indexPath.row])
        
        if postimgURL != nil {
            //let data = NSData(contentsOf: (postimgURL as URL?)!)
        
           // cell.postedImageView.image = UIImage(data:  data! as Data)
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

}

