//
//  MainTableViewController.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    //Signout
    @IBAction func logout(_ sender: Any) {
        print("App logout..")
        UserDefaults.standard.removeObject(forKey: "UserID")
        UserDefaults.standard.removeObject(forKey: "TokenID")
        self.dismiss(animated: true, completion: nil)
    }
    
    //About
    @IBAction func about(_ sender: Any) {
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybaord.instantiateViewController(withIdentifier: "AboutStoryBoard")
        // open screen
        self.present(vc, animated: true, completion: nil)
    }
    
    //Client
    @IBAction func gotoClient(_ sender: Any) {
        let storybaord = UIStoryboard(name: "Client", bundle: nil)
        let vc = storybaord.instantiateViewController(withIdentifier: "ClientStoryBoard")
        self.present(vc, animated: true, completion: nil)
    }
    

    
}
