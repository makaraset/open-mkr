//
//  CreateClientTableViewController.swift
//  open-mkr
//
//  Created by Makara on 2/20/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import UIKit
import SCLAlertView

class CreateClientTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, ClientServiceDelegate {
    
   
    let clientTemplateService = ClientTemplateService()
    let clientService = ClientService()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var externalIdTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    var genderPicker: UIPickerView! = UIPickerView()
    
    @IBOutlet weak var dataOfBirthDataPicker: UIDatePicker!
    
    
    @IBOutlet weak var clientTypetextField: UITextField!
    var clientTypePicker: UIPickerView! = UIPickerView()
    
    
    @IBOutlet weak var clientClassificationTextField: UITextField!
    var clientClassificationPicker: UIPickerView! = UIPickerView()
    
    
    @IBOutlet weak var branchTextField: UITextField!
    var branchPicker: UIPickerView! = UIPickerView()
    
    
    @IBOutlet weak var staffTextField: UITextField!
    var staffPicker: UIPickerView! = UIPickerView()
    
    var genders: [GenderOption] = []
    var clientTypes: [ClientType] = []
    var clientClasifications: [ClientClassification] = []
    var branches: [Branch] = []
    var staffs: [Staff] = []
    
    var selectedGender: GenderOption = GenderOption()
    var selectedClientType: ClientType = ClientType()
    var selectedClientClasification: ClientClassification = ClientClassification()
    var selectedBranch: Branch = Branch()
    var selectedStaff: Staff = Staff()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientService.delegate = self
        
        createPicker(pickerView: genderPicker, textField: genderTextField)
        createToolbar(textField: genderTextField)
        
        createPicker(pickerView: clientTypePicker, textField: clientTypetextField)
        createToolbar(textField: clientTypetextField)

        createPicker(pickerView: clientClassificationPicker, textField: clientClassificationTextField)
        createToolbar(textField: clientClassificationTextField)

        createPicker(pickerView: branchPicker, textField: branchTextField)
        createToolbar(textField: branchTextField)

        createPicker(pickerView: staffPicker, textField: staffTextField)
        createToolbar(textField: staffTextField)
        

    }

    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createClient(_ sender: Any) {
        
        //Date of birth
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: self.dataOfBirthDataPicker.date)
        dateFormatter.dateFormat = "MMM"
        let month: String = dateFormatter.string(from: self.dataOfBirthDataPicker.date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: self.dataOfBirthDataPicker.date)
        let dateOfBirth = "\(day) \(month) \(year)"
        
        //Current Date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let activationDate = formatter.string(from: date)
        
        //Display name
        let disName = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
        
        let client = ClientTemplate(clientId: 0, firstName: firstNameTextField.text!, middleName: middleNameTextField.text!, lastName: lastNameTextField.text!, displayName: disName , mobileNo: mobileNumberTextField.text!, externalId: externalIdTextField.text!, genderId: selectedGender.id, dob: dateOfBirth, clientTypeId: selectedClientType.id, clientClassificationId: selectedClientClasification.id, officeId: selectedBranch.id, staffId: selectedStaff.id, activationDate: activationDate)
        
        clientService.createClient(client: client)
        
    }
    
    func didAddedClient(error: Error?) {
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }

        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension CreateClientTableViewController{
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 12
    }
    
    
    //setup picker view
    func createPicker( pickerView: UIPickerView, textField: UITextField) {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        
        //Customizations
        pickerView.backgroundColor = .lightGray
    }
    
    
    func createToolbar(textField: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .gray
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    // Picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        if pickerView == genderPicker {
            return genders.count
        }else if pickerView == clientTypePicker {
            return clientTypes.count
        }else if pickerView == clientClassificationPicker {
            return clientClasifications.count
        }else if pickerView == branchPicker{
            return branches.count
        }else if pickerView == staffPicker {
            return staffs.count
        }
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == genderPicker {
            return genders[row].name
        }else if pickerView == clientTypePicker {
            return clientTypes[row].name
        }else if pickerView == clientClassificationPicker {
            return clientClasifications[row].name
        }else if pickerView == branchPicker{
            return branches[row].name
        }else if pickerView == staffPicker {
            return staffs[row].displayName
            
        }
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == genderPicker {
            selectedGender = genders[row]
            genderTextField.text = selectedGender.name
        }else if pickerView == clientTypePicker {
            selectedClientType = clientTypes[row]
            clientTypetextField.text = selectedClientType.name
        }else if pickerView == clientClassificationPicker {
            selectedClientClasification = clientClasifications[row]
            clientClassificationTextField.text = selectedClientClasification.name
        }else if pickerView == branchPicker{
            selectedBranch = branches[row]
            branchTextField.text = selectedBranch.name
        }else if pickerView == staffPicker {
            selectedStaff = staffs[row]
            staffTextField.text = selectedStaff.displayName
            
        }
        
    }
    
    
}




