//
//  ClientTableViewController.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import SCLAlertView
import NVActivityIndicatorView

class ClientTableViewController: UITableViewController, ClientServiceDelegate, NVActivityIndicatorViewable, UISearchResultsUpdating, ClientTemplateServiceDelegate {
    

    var clients: [Client] = []
    var pagination: Pagination = Pagination()
    var clientService = ClientService()
    var filteredData: [Client] = []
   
    
    var genders: [GenderOption] = []
    var clientTypes: [ClientType] = []
    var clientClasifications: [ClientClassification] = []
    var branches: [Branch] = []
    var staffs: [Staff] = []
    
    let clientTemplateService = ClientTemplateService()
    
    // Outlet
    @IBOutlet weak var footerindicator: UIActivityIndicatorView!
    @IBOutlet weak var footerView: UIView!
    
    // Outlet
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientService.delegate = self
        
        // TableView Property
         //tableView.estimatedRowHeight = UITableViewAutomaticDimension
         //tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add refresh control action
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing data...")
        self.refreshControl?.tintColor = .red
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
        
        
        getData(pageNumber: 1)
        setupSearchController()
        
        clientTemplateService.delegate = self
        clientTemplateService.getData()
        
    }
    
    
    func setupSearchController() {
        resultSearchController.searchBar.placeholder = "Search Client"
        navigationItem.hidesSearchBarWhenScrolling = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = .default
        resultSearchController.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.white]
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchResultsUpdater = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultSearchController
        }else {
            tableView.tableHeaderView = resultSearchController.searchBar
        }
    }
    
    // Get data by page number and limit(set static number 15)
    func getData(pageNumber: Int) {
        if pageNumber == 1 {
            // Create NVActivityIndicator
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: .ballBeat)
        }
        let url = DataManager.URL.CLIENT + DataManager.URL.CLIENTOPTION
        clientService.getData(pageNumber: pageNumber,url: url)
    }
    
    //Get filterd data
    func getData(pageNumber: Int, displayName: String) {
        if pageNumber == 1 {
            // Create NVActivityIndicator
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: .ballBeat)
        }

        let url = DataManager.URL.CLIENT + DataManager.URL.CLIENTOPTION + DataManager.URL.CLIENTSEARCH + "'%\(displayName)%'"
        
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        clientService.getData(pageNumber: pageNumber, url: escapedAddress!)

    }
    
    
    //Search Data
    func updateSearchResults(for searchController: UISearchController) {
        // Check if the user cancelled or deleted the search term so we can display the full list instead.
 
        if !self.footerindicator.isAnimating {
            // last display cell > or = amount of article
            if (searchController.searchBar.text?.count)! > 0 {
                
                // Current < total pages
                //if self.pagination.page < self.pagination.totalPages {
                    self.footerView.isHidden = false
                    self.footerindicator.startAnimating()
                    let searchText = resultSearchController.searchBar.text ?? ""
                    getData(pageNumber: 1 , displayName: searchText)
                //}
            }
        }
        
        tableView.reloadData()
    }
    
    // Refresh Control event
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        
        // Simply get data from first page which is latest data
        getData(pageNumber: 1)
    }
    
    
    func didRecievedClient(with clients: [Client]?, pagination: Pagination?, error: Error?) {
        
        self.stopAnimating() // Stop NVActivityIndicatorView
        // hide footer and indicator
        self.footerView.isHidden = true
        self.footerindicator.stopAnimating()
        self.refreshControl?.endRefreshing() // Stop animate refresh control
        
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        
        self.pagination = pagination!
        
        // if current == 1 means first request, else append data
        if self.pagination.page == 1 {
            self.clients.removeAll()
            self.clients = clients!
        }else {
            self.clients.append(contentsOf: clients!)
        }
        
        tableView.reloadData()
    }
    
    
    //Back
    @IBAction func exitClient(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCreate" {
        
           let destView = segue.destination as! CreateClientTableViewController
            destView.genders = self.genders
            destView.clientTypes = self.clientTypes
            destView.clientClasifications = self.clientClasifications
            destView.branches = self.branches
            destView.staffs = self.staffs
            
        }else if segue.identifier == "showClientDetail" {
            if resultSearchController.isActive {
                
                navigationController?.dismiss(animated: true, completion: nil)
                
            }
            let destView = segue.destination as! ClientDetailTableViewController
            destView.id = sender as? Int
            
        }
    }

}



// MARK: - Table view data source
extension ClientTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientTableViewCell", for: indexPath) as! ClientTableViewCell
        // Configure the cell...
        cell.configureCell(with: clients[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Data from each selected row
        let client = clients[indexPath.row]
        print(client.displayName)
        // Call Segue with ID
        self.performSegue(withIdentifier: "showClientDetail", sender: client.id)
        //navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //print("\(indexPath.section + 1)  == \(self.clients.count)")
        
        if !self.footerindicator.isAnimating {
            // last display cell > or = amount of article
            if indexPath.row + 1 >= self.clients.count {
                
                // Current < total pages
                if self.pagination.page < self.pagination.totalPages {
                    self.footerView.isHidden = false
                    self.footerindicator.startAnimating()
                    let searchText = resultSearchController.searchBar.text
                    if (searchText?.count)! > 0 {
                        getData(pageNumber: self.pagination.page + 1, displayName: searchText!)
                    }else {
                        getData(pageNumber: self.pagination.page + 1)
                    }
                }
            }
        }
    }
    
    func didRecievedClientTemplate(genderOtions: [GenderOption]?, clientTypes: [ClientType]?, clientClassfications: [ClientClassification]?, staffs: [Staff]?, branches: [Branch]?, error: Error?) {
        
        self.genders = genderOtions!
        self.clientTypes = clientTypes!
        self.clientClasifications = clientClassfications!
        self.branches = branches!
        self.staffs = staffs!
        
        print("orig gender \(genders.count)")
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //First remove file from DocumentDirectory
            clientService.deleteClient(by: clients[indexPath.row].id)
            
            //Remove object from array
            clients.remove(at: indexPath.row)
            
        }
    }
    
    func didDeletedClient(error: Error?) {
        
        //Check Error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        
        //Reload tableView
        self.tableView.reloadData()
    }
 
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            // find delete object by id
            let deleteMeal = self.mealService.getBy(id: self.displayedData[indexPath.row].objectID)
            
            // Delete
            self.mealService.delete(id: (deleteMeal?.objectID)!)
            self.displayedData.remove(at: indexPath.row)
            self.mealService.saveChange()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let editMeal = self.displayedData[indexPath.row]
            self.performSegue(withIdentifier: "showEdit", sender: editMeal)
        }
        
        editButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        deleteButton.backgroundColor = #colorLiteral(red: 0.9587053657, green: 0.3523139656, blue: 0.01222745888, alpha: 1)
        
        return [deleteButton, editButton]
    }*/
    
}

