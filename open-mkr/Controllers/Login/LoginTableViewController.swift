//
//  LoginTableViewController.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView
import NVActivityIndicatorView

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var userNameTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (UserDefaults.standard.string(forKey: "UserID") != nil) {
            self.showMainScreen(animation: false)
        }
    }

    func showMainScreen(animation: Bool) {
        // Open main screen
        // Create storybaord by name
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        
        // create veiw controller object by InitialViewController
        //let vc = storybaord.instantiateInitialViewController()
        
        // create veiw controller object by identifier
        let vc = storybaord.instantiateViewController(withIdentifier: "RootStorybaordID")
        
        // open screen
        self.present(vc, animated: animation, completion: nil)
    }
    
    // TODO: SignIn IBAction
    @IBAction func signInAction(_ sender: Any) {
        // Show loading
        let activityData = ActivityData(message: "Loading", type: NVActivityIndicatorType.circleStrokeSpin)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        // Sign in
        LoginService.shared.login(user: userNameTextView.text!, password: passwordTextView.text!) { (response, error) in
            // Close loading
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            // Check error from server
            if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
            
            // check response from server
            if let value = response?.result.value {
                let json = JSON(value) // Convert to SwiftyJSON
                // Check server code
                if let code = json["authenticated"].int, code == 1, let id = json["userId"].int {
                    let tokenId = json["base64EncodedAuthenticationKey"]
                    UserDefaults.standard.set("\(id)", forKey: "UserID")
                    UserDefaults.standard.set("\(tokenId)", forKey: "TokenID")
                }else { // error
                    print(json)
                    
                    SCLAlertView().showError("Error \(String(describing: json["httpStatusCode"].stringValue))", subTitle: json["defaultUserMessage"].stringValue); return
                }
            }else { // error
                SCLAlertView().showError("Error", subTitle: "Server error"); return
            }
            
            //Open main screen
            self.showMainScreen(animation: true)
            
        }
        
    }

}
