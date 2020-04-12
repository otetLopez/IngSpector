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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("DEBUG: viewDidAppear")
        if UserDefaults.standard.string(forKey: "email") != nil {
            // Then we have a data
            setFromUserDefaults()
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var rc : Bool = false
        if(identifier == "loginSuccess") {
            if logFlag == true {
                rc = true
                logFlag = false
            }
        }
        return rc
    }
    
    @objc func viewTapped() {
        tf_uname.resignFirstResponder()
        tf_pwd.resignFirstResponder()
    }
    
    @IBAction func logBtnPressed(_ sender: UIButton) {
        logFlag = false
        if(!checkFields()) {
            alert(title: "Error: ", msg: "Missing mandatory fields")
        } else {
            /* base: http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userlogin/t@d.com/1234 */
            let loginURL : String = serverConnection.getURLlogin() + "\(tf_uname.text!)/\(tf_pwd.text!)"
            print("DEBUG: LOGIN Credentials \(loginURL)")
            loginCredentials(url:  loginURL, email: "\(tf_uname.text!)")
        }
    }
    
    func setFromUserDefaults() {
        let email : String = UserDefaults.standard.string(forKey: "email") ?? ""
        let password : String = UserDefaults.standard.string(forKey: "password") ?? ""
        let name: String = UserDefaults.standard.string(forKey: "name") ?? ""
        let height : Double = UserDefaults.standard.double(forKey: "height")
        let weight : Double = UserDefaults.standard.double(forKey: "weight")
        let allergenList : [String] = UserDefaults.standard.stringArray(forKey: "allergenList") ?? [String]()
        let foodList : [String] = UserDefaults.standard.stringArray(forKey: "foodList") ?? [String]()
        currentUser = UserDetails(name: name, eadd: email, height: height, weight: weight, passwd: password, allergens: allergenList, food: foodList)
    }
    
    func setToUserDefaults(user: UserDetails) {
        UserDefaults.standard.set(user.getEmail(), forKey: "email")
        UserDefaults.standard.set(user.getPassword(), forKey: "password")
        UserDefaults.standard.set(user.getName(), forKey: "name")
        UserDefaults.standard.set(user.getHeight(), forKey: "height")
        UserDefaults.standard.set(user.getWeight(), forKey: "weight")
        UserDefaults.standard.set(user.getAllergens(), forKey: "allergenList")
        UserDefaults.standard.set(user.getFoodList(), forKey: "foodList")
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
                    //print("DEBUG: sendRequest Retrieved JSON data \(dataJSON)")
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
        /*{"email":"rosette@test.com","password":"123456","name":"rosette","height":"170","weight":"50",
         "allergens":"peanut,milk","allergicFoods":""} */
        if let email = dataJSON["email"].string {
            let password = (dataJSON["password"].string)!
            let name = (dataJSON["name"].string)!
            let height = (dataJSON["height"].string)!
            let weight = (dataJSON["weight"].string)!
            let allergens = (dataJSON["allergens"].string)!
            let allergicFoods = (dataJSON["allergicFoods"].string)!
            
            var allergenList = [String]()
            if(allergens.count > 0) {
                allergenList = parseList(toParse: allergens)
                for idx in allergenList {
                    print("DEBUG: Allergen -> \(idx)")
                }
            }
            
            var foodList = [String]()
            if(allergicFoods.count > 0) {
                foodList = parseList(toParse: allergicFoods)
                for idx in foodList {
                    print("DEBUG: FoodList -> \(idx)")
                }
            }
            
            print("DEBUG: userInfo \(email) \(password) \(name) \(height) \(weight) \(allergens) \(allergicFoods)")
            let user = UserDetails(name: name, eadd: email, height: Double(height)!, weight: Double(weight)!, passwd: password, allergens: allergenList, food: foodList)
            currentUser = user
            setToUserDefaults(user: user)
            logFlag = true
            performSegue(withIdentifier: "loginSuccess", sender: nil)
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
    
    func parseList(toParse: String) -> [String] {
        let parsed : [String] = toParse.split{$0 == ","}.map(String.init)
        return parsed
    }
    
    /* Note, this to delete */
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
