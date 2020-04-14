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
import MessageUI

class LogInViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tf_uname: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var psswdBtn: UIButton!
    
    var serverConnection = ServerConnection()
    var defaultsAccess = DefaultsAccess()
    var currentUser = UserDetails()
    var logFlag : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
        
        // Make sure keyboard hides after typing
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
        if UserDefaults.standard.string(forKey: "email") != nil {
            // We get the latest data from server
            requestUserInfo(email: defaultsAccess.getEmailFromDefaults())
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var rc : Bool = false
        if(identifier == "loginSuccess") {
            if logFlag == true {
                rc = true
                logFlag = false
            }
        } else { rc = true }
        return rc
    }
    
    @objc func viewTapped() {
        tf_uname.resignFirstResponder()
        tf_pwd.resignFirstResponder()
    }
    
    @IBAction func logBtnPressed(_ sender: UIButton) {
        logFlag = false
        //SVProgressHUD.setForegroundColor(UIColor(displayP3Red: 255/255, green: 111/255, blue: 207/255, alpha: 1.00))
        //SVProgressHUD.show(withStatus: "Logging in...")
        
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setDefaultMaskType(.custom)
//        SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
//        SVProgressHUD.setBackgroundColor(UIColor.yellow)        //HUD Color
//        SVProgressHUD.setBackgroundLayerColor(UIColor.green)    //Background Color
//        SVProgressHUD.show()
        
        
        if(!checkFields()) {
            alert(title: "Error: ", msg: "Missing mandatory fields")
        } else {
            /* base: http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userlogin/t@d.com/1234 */
            let loginURL : String = serverConnection.getURLlogin() + "\(tf_uname.text!)/\(tf_pwd.text!)"
            print("DEBUG: LOGIN Credentials \(loginURL)")
            loginCredentials(url:  loginURL, email: "\(tf_uname.text!)")
        }
    }
    
    func loginCredentials(url: String, email: String) {
        AF.request(url, method: .get).responseJSON {
        response in
            switch response.result {
                case let .success(value):
                    let dataJSON : JSON = JSON(value)
                    print("DEBUG: \(value) \(true) \(false) \(dataJSON)")
                    if dataJSON == true {
                        self.requestUserInfo(email: email)
                    } else {
                        // Alert log In unsuccessful
                    }
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    func sendUserInfoRequest(url: String, email: String) {
        AF.request(url, method: .get).responseJSON {
        response in
            switch response.result {
                case let .success(value):
                    let dataJSON : JSON = JSON(value)
                    self.parseUserInfo(dataJSON: dataJSON)
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    func requestUserInfo(email: String) {
        /* http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userinfo/rosette@test.com/get */
        let url : String = serverConnection.getURLinfo() + "\(email)/get"
        print("DEBUG: Retrieve user details \(url)")
        sendUserInfoRequest(url: url, email: email)
    }
    
    func parseUserInfo(dataJSON: JSON) {
        print("DEBUG: parseUserInfo() This is what we have from server \(dataJSON)")
        currentUser  = serverConnection.parseUserInfo(dataJSON: dataJSON)
        defaultsAccess.setToUserDefaults(user: currentUser)
        logFlag = true
        //SVProgressHUD.dismiss()
        performSegue(withIdentifier: "loginSuccess", sender: nil)
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
        
        psswdBtn.isHidden = true
        
        logInBtn.layer.cornerRadius = 10
        tf_uname.layer.borderWidth = 0
        tf_uname.layer.cornerRadius = 10
        tf_uname.text = ""
        tf_pwd.layer.borderWidth = 0
        tf_pwd.layer.cornerRadius = 10
        tf_pwd.text = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let log_delegate = segue.destination as? HomeViewController {
            log_delegate.home_delegate = self
        }
    }
}
