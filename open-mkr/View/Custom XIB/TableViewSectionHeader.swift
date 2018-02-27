//
//  TableViewSectionHeader.swift
//  ServerCommunication
//
//  Created by Kokpheng on 11/10/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewSectionHeader: UITableViewHeaderFooterView {


    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func configureCell(_ productType: String, _ noAccount: Int)  {
        
        productTypeLabel.text = productType
        noAccountLabel.text = "\(noAccount)"
    }
}
