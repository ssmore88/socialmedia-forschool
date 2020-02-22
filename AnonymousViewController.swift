//
//  AnonymousViewController.swift
//  bruincave
//
//  Created by user128030 on 7/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class AnonymousViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var anonymousTableView: UITableView!
    
    @IBAction func postAnonymousComment(_ sender: Any) {
        let anonymousPostVC = self.storyboard?.instantiateViewController(withIdentifier: "anonymousPostController") as! SWRevealViewController
        self.present(anonymousPostVC, animated: true, completion: nil)
    }
    
    var idArray = [Int]()
    var bodyArray = [String]()
    var timeArray = [String]()
    var commentsCountArray = [String]()
    let cellSpacingHeight: CGFloat = 25
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        
        let myUrl = URL(string: "http://www.bruincave.com/m/andriod/bringcrush.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "o=0";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if json != nil {
                    
                    if let postArray = json?["crush"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let body = postDict.value(forKey: "body") {
                                    self.bodyArray.append(body as! String)
                                }
                                if let time = postDict.value(forKey: "time_added") {
                                    self.timeArray.append(time as! String)
                                }
                                if let id = postDict.value(forKey: "id") {
                                    self.idArray.append(id as! Int)
                                }
                                if let commentsCount = postDict.value(forKey: "commentscount") {
                                    self.commentsCountArray.append(commentsCount as! String)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.anonymousTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    
    func tableView(_ anonymousTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyArray.count
    }
    
    
    func tableView(_ anonymousTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = anonymousTableView.dequeueReusableCell(withIdentifier: "anonymouscell") as! AnonymousTableViewCell
        
        cell.bodyLabel.text = bodyArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        cell.commentsCountLabel.text = commentsCountArray[indexPath.row]
        cell.onViewCommentsTapped = {
            let defaults = UserDefaults.standard
            defaults.set(self.idArray[indexPath.row], forKey: "anonymouscommentsid")
     
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "anonymousC")
            
            self.present(newViewController, animated: true, completion: nil)

        }
        
        cell.separatorInset = UIEdgeInsetsMake(40, 50, 40, 50)
        cell.layer.borderWidth = 5
        let color = UIColor(red:0.20, green:0.25, blue:0.35, alpha:1.0)
        cell.layer.borderColor = color.cgColor
     
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
