//
//  SeniorViewController.swift
//  bruincave
//
//  Created by user128030 on 7/27/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class SeniorViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenus()
        
        //change tab picture
        self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "seniorfilled")
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
