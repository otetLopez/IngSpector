//
//  RegisterViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import SVProgressHUD
import Reachability

class RegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var log_delegate: LogInViewController?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_eadd: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var tf_cpwd: UITextField!
    @IBOutlet weak var tf_height: UITextField!
    @IBOutlet weak var tf_weight: UITextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let internetConnection = InternetConnection()
    var allergenList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            self.view.addGestureRecognizer(tapGesture)
        
        //Notify user of internet connection
        let connection : Bool = checkInternet()
    }
    
    @objc func viewTapped() {
        tf_name.resignFirstResponder()
        tf_eadd.resignFirstResponder()
        tf_pwd.resignFirstResponder()
        tf_cpwd.resignFirstResponder()
        tf_height.resignFirstResponder()
        tf_weight.resignFirstResponder()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
      alertCancel(title: "Cancelling Registration", msg: "Are you sure?")
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        checkFields()
    }
    
    @IBAction func addAllergenList(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Allergens", message: "Enter an ingredient you are allergic to", preferredStyle: .alert)
        var nAllergen : UITextField?
        
        alertController.addTextField { (nAllergen) in
            nAllergen.placeholder = "e.g. Peanut"
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textField = alertController.textFields![0]
            print("DEBUG: RegisterViewController::addAllergenList(): Will be adding folder \(textField.text!)")
            self.addAllergen(allergen: "\(textField.text!)")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cancelRegistration() {
        clearFields()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func clearFields() {
        tf_name.text = ""
        tf_eadd.text = ""
        tf_pwd.text = ""
        tf_cpwd.text = ""
        tf_height.text = ""
        tf_weight.text = ""
    }
    
    func sendDataToServer(newUser : UserDetails) {
        if(checkInternet()) {
            // We have internet connection now we send the register information to server
            
        }
    }
    
    func createUser() -> Bool{
        let ht : Double = Double(tf_height.text!)!
        let wt : Double = Double(tf_weight.text!)!
        print("DEBUG: \(ht)\(wt)")
        let newUser = UserDetails(name: tf_name.text!, eadd: tf_eadd.text!, height: Double(tf_height.text!)!, weight: Double(tf_weight.text!)!, passwd: tf_pwd.text!, allergens: allergenList, food: [String]())
        log_delegate?.addUserFromRegister(newUser: newUser)
        
        //TODO: Send these data into server to check if email is valid
        sendDataToServer(newUser : newUser)
        
        return true
    }
    
    func checkFields() {
        var isIncomplete : Bool = false
        if tf_name.text!.isEmpty {
            tf_name.layer.borderWidth = 1
            tf_name.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_name.layer.borderWidth = 0
        }
        if tf_eadd.text!.isEmpty {
            tf_eadd.layer.borderWidth = 1
            tf_eadd.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_eadd.layer.borderWidth = 0
        }
        if tf_pwd.text!.isEmpty {
            tf_pwd.layer.borderWidth = 1
            tf_pwd.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_pwd.layer.borderWidth = 0
        }
        if tf_cpwd.text!.isEmpty {
            tf_cpwd.layer.borderWidth = 1
            tf_cpwd.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_cpwd.layer.borderWidth = 0
        }
        if tf_height.text!.isEmpty {
            tf_height.layer.borderWidth = 1
            tf_height.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_height.layer.borderWidth = 0
        }
        if tf_weight.text!.isEmpty {
            tf_weight.layer.borderWidth = 1
            tf_weight.layer.borderColor = UIColor.red.cgColor
            isIncomplete = true
        } else {
            tf_weight.layer.borderWidth = 0
        }
        
        if(isIncomplete == true) {
            alertErrors(msg: "Missing fields")
        } else {
            /* Check passwords */
            if isPasswordValid() == true {
                let rc : Bool = createUser()
                let msg : String = rc ? "Register Successful" : "Register Unsuccesful"
                showToastMsg(msg: msg, done: rc, seconds: 2)
                if rc == true {
                    clearFields()
                }
            }
        }
    }
    
    func isPasswordValid() -> Bool {
        var isPwdValid : Bool = true
        /* Check if password is Strong */
        if tf_pwd.text?.count ?? 0 < 6 {
            print("DEBUG: RegisterViewController isPasswordValid() Password Weak")
            alertErrors(msg: "Password Weak")
            isPwdValid = false
        } else if tf_pwd.text! != tf_cpwd.text! {
            print("DEBUG: RegisterViewController isPasswordValid() Passwords did not match")
            alertErrors(msg: "Passwords did not match")
            isPwdValid = false
        }
        
        if isPwdValid == false {
            tf_pwd.layer.borderWidth = 1
            tf_pwd.layer.borderColor = UIColor.red.cgColor
            tf_cpwd.layer.borderWidth = 1
            tf_cpwd.layer.borderColor = UIColor.red.cgColor
        } else {
            tf_pwd.layer.borderWidth = 0
            tf_cpwd.layer.borderWidth = 0
        }
        
        return isPwdValid
    }
    
    func addAllergen(allergen : String) {
        allergenList.append(allergen)
        tableView.reloadData()
    }
    
    func removeAllergen(allergen : String) {
        
    }
    
    func checkInternet() -> Bool {
        let connection : Bool = internetConnection.isConnected()
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", done: false, seconds: 3)
        }
        return connection
    }
    
    func alertErrors(msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertCancel(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            self.cancelRegistration()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToastMsg(msg: String, done: Bool, seconds: Double) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController.view.alpha = 0.5
        alertController.view.layer.cornerRadius = 15
        
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alertController.dismiss(animated: true)
            if(done) { self.navigationController?.popToRootViewController(animated: true) }
        }
    }

    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        cancelBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
        
        // Name
        let l_name = CALayer()
        l_name.frame = CGRect(x: 0.0, y: tf_name.frame.height - 1, width: tf_name.frame.width, height: 1.0)
        l_name.backgroundColor = UIColor.white.cgColor
        tf_name.layer.addSublayer(l_name)
        tf_name.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Email
        let l_email = CALayer()
        l_email.frame = CGRect(x: 0.0, y: tf_eadd.frame.height - 1, width: tf_eadd.frame.width, height: 1.0)
        l_email.backgroundColor = UIColor.white.cgColor
        tf_eadd.layer.addSublayer(l_email)
        tf_eadd.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Height
        let l_ht = CALayer()
        l_ht.frame = CGRect(x: 0.0, y: tf_height.frame.height - 1, width: tf_height.frame.width, height: 1.0)
        l_ht.backgroundColor = UIColor.white.cgColor
        tf_height.layer.addSublayer(l_ht)
        tf_height.attributedPlaceholder = NSAttributedString(string: "Height (m)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Weight
        let l_wt = CALayer()
        l_wt.frame = CGRect(x: 0.0, y: tf_weight.frame.height - 1, width: tf_weight.frame.width, height: 1.0)
        l_wt.backgroundColor = UIColor.white.cgColor
        tf_weight.layer.addSublayer(l_wt)
        tf_weight.attributedPlaceholder = NSAttributedString(string: "Weight (kg)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Password
        let l_pwd = CALayer()
        l_pwd.frame = CGRect(x: 0.0, y: tf_pwd.frame.height - 1, width: tf_pwd.frame.width, height: 1.0)
        l_pwd.backgroundColor = UIColor.white.cgColor
        tf_pwd.layer.addSublayer(l_pwd)
        tf_pwd.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // Confirm Password
        let l_cpwd = CALayer()
        l_cpwd.frame = CGRect(x: 0.0, y: tf_cpwd.frame.height - 1, width: tf_cpwd.frame.width, height: 1.0)
        l_cpwd.backgroundColor = UIColor.white.cgColor
        tf_cpwd.layer.addSublayer(l_cpwd)
        tf_cpwd.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func configure_tf() {
        
    }
    
    /* Here are the table view functions */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = " \(indexPath.row + 1) \(allergenList[indexPath.row])"
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allergenList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
