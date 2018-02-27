//
//  ClientDetailTableViewController.swift
//  open-mkr
//
//  Created by Makara on 2/8/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import SCLAlertView

class ClientDetailTableViewController: UITableViewController, ClientDetailServiceDelegate  {
    

    @IBOutlet weak var accountNo: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    
    var accounts: [Account] = []
    var clientDetailService = ClientDetailService()
    
    var id: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientDetailService.delegate = self
               
        // register class
        let nib = UINib(nibName: "TableViewSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableViewSectionHeaderIdentifier") // register and set identifier
        tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension

        if let clId = id{
            print("Id==> \(clId)")
            
            getClientAccount(id: clId)
        }
        
    }
    
    func getClientAccount(id: Int) {
        clientDetailService.getClientAccount(id: id)
    }
    
    func didRecievedClientAccount(with accounts: [Account]?, error: Error?) {
        
        print("Received Account.....")
        //print(accounts)
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        self.accounts = accounts!
        for ac in accounts!{
            print("Account No: \(ac.accountNo), Product Type: \(ac.productType), Balance: \(ac.balance)")
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.accounts.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewSectionHeaderIdentifier") as! TableViewSectionHeader
        let account = self.accounts[section]
        
        headerCell.configureCell(account.productType, account.totalAccount)
        return headerCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! ClientDetailTableViewCell
        
        // Configure the cell...
        print( "Row: \(indexPath.row) , Section: \(indexPath.section)")
        print(self.accounts.count)
        
        cell.configureCell(with: self.accounts[indexPath.section])
        
        return cell
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    


}


