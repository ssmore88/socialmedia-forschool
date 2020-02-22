//
//  AnonymousCommentsViewController.swift
//  bruincave
//
//  Created by user128030 on 11/23/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class AnonymousCommentsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var anonymousCommentsTableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postAnonymousComment(_ sender: Any) {
        let anonymousCPostVC = self.storyboard?.instantiateViewController(withIdentifier: "anonymousCPost") as! SWRevealViewController
        self.present(anonymousCPostVC, animated: true, completion: nil)
    }
    
    var bodyArray = [String]()
    let cellSpacingHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let commentsidSet: String = defaults.string(forKey: "anonymouscommentsid")!
        
        let myUrl = URL(string: "http://www.bruincave.com/m/ios/bringanoncomments.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "postid="+commentsidSet;
        defaults.set(nil, forKey: "anonymouscommentsid")
        
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
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.anonymousCommentsTableView.reloadData()
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
        let cell = anonymousTableView.dequeueReusableCell(withIdentifier: "anonymouscommentscell") as! AnonymousCommentsTableViewCell
        
        cell.bodyLabel.text = bodyArray[indexPath.row]
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
