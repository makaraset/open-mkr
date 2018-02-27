//
//  ClientDetailService.swift
//  open-mkr
//
//  Created by Makara on 2/13/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

protocol ClientDetailServiceDelegate {
    func didRecievedClientAccount(with accounts: [Account]?, error: Error?)
}

extension ClientServiceDelegate{
    func didRecievedClientAccount(with accounts: [Account]?, error: Error?){}
}

class ClientDetailService {
    
    var delegate: ClientDetailServiceDelegate?
    
    func getClientAccount(id: Int) {
        let url = "\(DataManager.URL.CLIENTOVERVIEW)\(id)\(DataManager.URL.CLIENTOVERVIEWSUFFIX)"
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                //print(response)
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    //let clients =  json["pageItems"].arrayValue.map{ Client($0) }
                    
//                    print(json)
                    
                    let loanAccountsJson = json["loanAccounts"].arrayValue
                    let savingAccountsJson = json["savingsAccounts"].arrayValue
                    
                    var accounts: [Account] = []
                    
                    
                    var totalLn: Int = 0
                    var totalSa: Int = 0
                    
                    for ln in loanAccountsJson{
                        if ln["status"]["id"].intValue == 300 {
                            totalLn += 1
                        }
                    }
                    
                    for ln in loanAccountsJson{
                        if ln["status"]["id"].intValue == 300 {
                            accounts.append(Account(id: ln["id"].intValue, accountNo: ln["accountNo"].stringValue, balance: ln["loanBalance"].doubleValue, accountType: ln["productName"].stringValue, productType: "Loan Account", totalAccount: totalLn))
                           
                        }else{
                            print("Exclude: \(ln["status"]["id"].intValue)")
                        }
                    }
                    
                    //print(loanAccountsJson)
                    
                    for sa in savingAccountsJson{
                        if sa["status"]["id"].intValue == 300 {
                           totalSa += 1
                        }
                    }
                    
                    for sa in savingAccountsJson{
                        if sa["status"]["id"].intValue == 300 {
                            accounts.append(Account(id: sa["id"].intValue, accountNo: sa["accountNo"].stringValue, balance: sa["accountBalance"].doubleValue, accountType: sa["productName"].stringValue, productType: "Saving Account" , totalAccount: totalSa))
                        }else{
                            print("Exclude: \(sa["status"]["id"].intValue)")
                        }
                    }
                    
                    //print(savingAccountsJson)
                    
                    self.delegate?.didRecievedClientAccount(with: accounts, error: nil)
                    
                    //self.delegate?.didRecievedClient(with: clients, pagination: pagination, error: nil)
                    
                case .failure(let error):
                    self.delegate?.didRecievedClientAccount(with: nil, error: error)
                }
        }
    }
    
    
}
