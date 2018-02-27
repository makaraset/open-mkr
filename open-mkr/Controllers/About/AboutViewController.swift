//
//  AboutViewController.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAbout(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
