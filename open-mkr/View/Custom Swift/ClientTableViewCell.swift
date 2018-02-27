//
//  ClientTableViewCell.swift
//  open-mkr
//
//  Created by Makara on 2/4/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class ClientTableViewCell: UITableViewCell {

    //Cell Outlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    
    func configureCell(with client: Client) {
        // Set data to control
        displayNameLabel.text = client.displayName
        accountLabel.text = client.accountNo
        phoneNoLabel.text = client.mobileNo
        
        let clientService = ClientService()
       
        clientService.getClientImage(id: client.id) { (response, error) in
            // Check error from server
            if let err = error { self.photoImageView.image = #imageLiteral(resourceName: "user"); return }
            
            
            if let image = response?.result.value {
                //print("image downloaded: \(image)")
                self.photoImageView.image = response?.value?.af_imageRoundedIntoCircle()
            }else { // error
                self.photoImageView.image = #imageLiteral(resourceName: "user")
            }
            
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
