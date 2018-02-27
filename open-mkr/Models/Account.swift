//
//  Account.swift
//  open-mkr
//
//  Created by Makara on 2/13/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account {
    
    var id: Int
    var accountNo: String
    var balance: Double
    var accountType: String
    var productType: String
    var totalAccount: Int
    
    init(id: Int, accountNo: String, balance: Double, accountType: String, productType: String, totalAccount: Int) {
        self.id = id
        self.accountNo = accountNo
        self.balance = balance
        self.accountType = accountType
        self.productType = productType
        self.totalAccount = totalAccount
    }
    
}
