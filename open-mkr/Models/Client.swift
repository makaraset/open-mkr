//
//  Client.swift
//  open-mkr
//
//  Created by Makara on 2/2/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import SwiftyJSON

class Client {
    var id: Int
    var displayName: String
    var officeName: String
    var accountNo: String
    var mobileNo: String
    
    init(_ data: JSON) {
        
        id = data["id"].intValue
        displayName = data["displayName"].string ?? ""
        officeName = data["officeName"].string ?? ""
        accountNo = data["accountNo"].string ?? ""
        mobileNo = data["mobileNo"].string ?? ""
    }
}
