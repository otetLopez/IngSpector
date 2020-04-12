//
//  FirstPageViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var tf_uname: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    
    var userList = [UserDetails]()
    var emailList = [String]()
    var serverConnection = ServerConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* TODO*/
        /* OTET: We need to check if the user is logged in, if so, there is no need to display this page
                 and we will proceed to Home Page*/
        
        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
        
        // Make sure keyboard hides after typing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        /* Connect to Server */
        
        
        /* Retrieve list of users from server */
        retrieveUsersFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    @objc func viewTapped() {
        tf_uname.resignFirstResponder()
        tf_pwd.resignFirstResponder()
    }
    
    @IBAction func logBtnPressed(_ sender: UIButton) {
        if(!checkFields()) {
            alert(title: "Error: ", msg: "Missing mandatory fields")
        } else {
            /* base: http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userlogin/t@d.com/1234 */
            let loginURL : String = serverConnection.getURLlogin() + "\(tf_uname.text!)/\(tf_pwd.text!)"
            print("DEBUG: LOGIN Credentials \(loginURL)")
            loginCredentials(url:  loginURL)
        }
    }
    
    func loginCredentials(url: String) {
        AF.request(url, method: .get).responseJSON {
        response in
            switch response.result {
                case let .success(value):
                    let dataJSON : JSON = JSON(value)
                    print("DEBUG: \(value) \(true) \(false) \(dataJSON)")
                    if dataJSON == true {
                        //SVProgressHUD.dismiss();
                        //self.parseLoginInfo(json: dataJSON);
                    }
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    func checkFields() -> Bool {
        if tf_uname.text!.isEmpty || tf_pwd.text!.isEmpty {
            if tf_uname.text!.isEmpty {
                tf_uname.layer.borderWidth = 1
                tf_uname.layer.borderColor = UIColor.red.cgColor
            } else {
                tf_uname.layer.borderWidth = 0
            }
            
            if tf_pwd.text!.isEmpty {
                tf_pwd.layer.borderWidth = 1
                tf_pwd.layer.borderColor = UIColor.red.cgColor
            } else {
                tf_pwd.layer.borderWidth = 0
            }
            return false
        }
        return true
    }
    
    func alert(title: String, msg : String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        logInBtn.layer.cornerRadius = 10
        tf_uname.layer.borderWidth = 0
        tf_uname.layer.cornerRadius = 10
        tf_uname.text = ""
        tf_pwd.layer.borderWidth = 0
        tf_pwd.layer.cornerRadius = 10
        tf_pwd.text = ""
        
    }
    
    func addUserFromRegister(newUser : UserDetails) {
        userList.append(newUser)
        for idx in userList {
            print("\(idx)")
        }
    }
    
    func retrieveUsersFromServer() {
        setUserDefaultsFromServer()
    }
    
    func setUserDefaultsFromServer() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reg_delegate = segue.destination as? RegisterViewController {
            reg_delegate.log_delegate = self
        } else if let log_delegate = segue.destination as? HomeViewController {
            log_delegate.home_delegate = self
        }
    }
}
