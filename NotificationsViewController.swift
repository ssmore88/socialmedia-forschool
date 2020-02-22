//
//  NotificationsViewController.swift
//  bruincave
//
//  Created by user128030 on 7/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var notificationsTableView: UITableView!
    
    @IBAction func searchUsers(_ sender: Any) {
        let searchUserVC = self.storyboard?.instantiateViewController(withIdentifier: "searchView") as! SWRevealViewController
        self.present(searchUserVC, animated: true, completion: nil)
    }
    
    var bodyArray = [String]()
    var timeArray = [String]()
    var fromPicArray = [String]()
    var postIdArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let usernameSet: String = defaults.string(forKey: "username")!
        
        sideMenus()
        
        let myUrl = URL(string: "http://www.bruincave.com/m/andriod/bringnotifications.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST" // Compose a query string
        
        let postString = "o=0&user="+usernameSet
        print(postString)
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    if let postArray = json?["notifications"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let frompic = postDict.value(forKey: "fromPic") {
                                    self.fromPicArray.append(frompic as! String)
                                    print(frompic as! String)
                                }
                                if let body = postDict.value(forKey: "body") {
                                    
                                    self.bodyArray.append(body as! String)
                                }
                                if let postid = postDict.value(forKey: "postid") {
                                    self.postIdArray.append(postid as! Int)
                                }
                                if let time_added = postDict.value(forKey: "time_added") {
                                    self.timeArray.append(time_added as! String)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.notificationsTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    func tableView(_ notificationsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromPicArray.count
    }
    
    
    func tableView(_ notificationsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "notificationscell") as! NotificationsTableViewCell
        
        cell.bodyLabel.text = bodyArray[indexPath.row]
        cell.dateLabel.text = timeArray[indexPath.row]
        
        let postimgURL = NSURL(string: fromPicArray[indexPath.row])
        
        if postimgURL != nil {
            let data = NSData(contentsOf: (postimgURL as URL?)!)
            
            cell.fromPicImage.image = UIImage(data:  data! as Data)
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
