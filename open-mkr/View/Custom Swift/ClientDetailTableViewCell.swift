//
//  ClientTableViewCell.swift
//  open-mkr
//
//  Created by Makara on 2/14/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class ClientDetailTableViewCell: UITableViewCell {

    //Cell Outlet
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    

    
    func configureCell(with account: Account) {
        // Set data to control
        accountNoLabel.text = account.accountNo
        balanceLabel.text = account.balance.formatnumber()
        accountTypeLabel.text = account.accountType
        
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension Double {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
}
